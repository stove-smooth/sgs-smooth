//
//  FriendInfoViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/21.
//

import RxSwift
import RxCocoa

class FriendInfoViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let friendService: FriendServiceProtocol
    
    var friend: Friend
    
    struct Input {
        let tapBanButton = PublishRelay<Void>()
        let tapDeleteButton = PublishRelay<Void>()
    }
    
    struct Output {
        let dismiss = PublishRelay<Void>()
    }
    
    init(
        friendService: FriendServiceProtocol,
        friend: Friend
    ) {
        self.friendService = friendService
        self.friend = friend
        super.init()
    }
    
    override func bind() {
        self.input.tapBanButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.banFriend()
            })
            .disposed(by: disposeBag)
        
        self.input.tapDeleteButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.deleteFriend()
            })
            .disposed(by: disposeBag)
    }
    
    // TODO: 얼럿 통해서 친구 변동 있을 경우 ListView 변동사항 반영
    private func banFriend() {
        self.friendService.banFriend(self.friend.id) {  response, error in
            guard let response = response else {
                return
            }
            
            if response.isSuccess {
                self.output.dismiss.accept(())
            } else {
                self.showErrorMessage.accept(response.message)
            }
        }
    }
    
    private func deleteFriend() {
        self.friendService.deleteFriend(self.friend.id) {  response, error in
            guard let response = response else {
                return
            }
            
            if response.isSuccess {
                self.output.dismiss.accept(())
            } else {
                self.showErrorMessage.accept(response.message)
            }
        }
    }
}
