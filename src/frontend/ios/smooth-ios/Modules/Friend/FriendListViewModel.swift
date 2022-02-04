//
//  FriendViewModel.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import RxSwift
import RxCocoa

class FriendListViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let friendService: FriendService
    
    struct Input {
        let tapRequestButton = PublishSubject<Void>()
        let tapRejectButton = PublishRelay<Friend>()
        let tapAcceptButton = PublishRelay<Friend>()
    }
    
    struct Output {
        let sections = PublishRelay<[FriendSection]>()
        let showLoading = PublishRelay<Bool>()
        let showEmpty = PublishRelay<Bool>()
        
        let goToRequest = PublishRelay<Void>()
    }
    
    init(friendService: FriendService) {
        self.friendService = friendService
        super.init()
    }
    
    func fetchFriend() {
        self.output.showLoading.accept(true)
        
        self.friendService.fetchFriend { friends, _ in
            guard let friends = friends else {
                return
            }
            
            self.output.sections.accept(friends)
            self.output.showLoading.accept(false)
            
            if friends.count == 0 {
                self.output.showEmpty.accept(true)
            } else {
                self.output.showEmpty.accept(false)
            }
        }
    }
    
    override func bind() {
        self.input.tapRequestButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.output.goToRequest.accept(())
            })
            .disposed(by: disposeBag)
        
        self.input.tapRejectButton
            .asDriver(onErrorJustReturn: Friend.init())
            .drive(onNext: { friend in
                self.friendService.deleteFriend(friend.id) { response, error in
                    
                    guard let response = response else {
                        return
                    }
                    
                    if (response.isSuccess) {
                        self.fetchFriend()
                    } else {
                        self.showErrorMessage.accept(response.message)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        self.input.tapAcceptButton
            .asDriver(onErrorJustReturn: Friend.init())
            .drive(onNext: { friend in
                self.friendService.acceptFriend(friend.id) { response, _ in
                    guard let response = response else {
                        return
                    }
                    
                    if (response.isSuccess) {
                        self.fetchFriend()
                    } else {
                        self.showErrorMessage.accept(response.message)
                    }

                }
            })
            .disposed(by: disposeBag)
    }
}
