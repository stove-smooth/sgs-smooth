//
//  FriendViewModel.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import RxSwift
import RxCocoa

class FriendViewModel: BaseViewModel {
    let input = Input()
    let output = Output()

    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
        let tapRequestButton = PublishSubject<Void>()
        let getFriendList = ReplaySubject<Void>.create(bufferSize: 1)
        
       
    }
    
    struct Output {
        let isLoading = BehaviorRelay<Bool>(value: true)
        let goToRequest = PublishRelay<Void>()
        
        let tapRejectButton = BehaviorRelay<Friend?>(value: nil)
    }
    
    let sections = BehaviorRelay<[FriendSection]>(value: [])
    
    func loadFriend() {
        FriendRepository.fetchFriend { friends, _ in
            guard let friends = friends else {
                return
            }
            self.output.isLoading.accept(false)
            self.sections.accept(friends)
        }
    }
    
    override func bind() {
        self.input.tapRequestButton
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.output.goToRequest.accept(())
            })
            .disposed(by: disposeBag)
        
        self.sections
            .asDriver()
            .drive(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
        
//        self.output.tapRejectButton
//            .asDriver()
//            .drive(onNext: { friend in
//                print("drive reject button \(friend)")
//                guard let friend = friend else { return }
//                        
//                FriendRepository.deleteFriend(DeleteFriendRequest(id: friend.id)) { response, _ in
//                    print("delete friend")
//                }
//            })
//            .disposed(by: disposeBag)
    }
}
