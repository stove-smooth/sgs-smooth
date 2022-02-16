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
    var model: Model
    
    let friendService: FriendServiceProtocol
    let userService: UserServiceProtocol
    
    struct Input {
        let fetch = PublishSubject<Void>()
        let tapBanButton = PublishRelay<Void>()
        let tapDeleteButton = PublishRelay<Void>()
    }
    
    struct Output {
        let dismiss = PublishRelay<Void>()
        let friend = PublishRelay<Friend>()
    }
    
    struct Model {
        var friend = Friend()
        let friendId: Int
    }
    
    init(
        friendService: FriendServiceProtocol,
        userService: UserServiceProtocol,
        friendId: Int
    ) {
        self.friendService = friendService
        self.userService = userService
        self.model = Model(friendId: friendId)
        super.init()
    }
    
    override func bind() {
        self.input.fetch
            .subscribe(onNext: {
                self.fetchFriendInfo(userId: self.model.friendId)
            })
            .disposed(by: disposeBag)
        
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
        self.friendService.banFriend(model.friendId) {  response, error in
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
        self.friendService.deleteFriend(model.friendId) {  response, error in
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
    
    private func fetchFriendInfo(userId: Int) {
        userService.fetchUserInfoById(userId: userId) {
            response, error in
            
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                guard let userInfo = response else {
                    return
                }

                self.model.friend = Friend(id: -1,
                                           userId: userId,
                                           name: userInfo.name,
                                           code: userInfo.code,
                                           profileImage: userInfo.profileImage,
                                           state: .none)
                
                self.output.friend.accept(self.model.friend)
            }
        }
    }
}
