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
        let friendInfo = PublishRelay<Friend>()
    }
    
    struct Model {
        var friendInfo = Friend()
        let userId: Int
        var friendId: Int?
        var friendList: [Friend] = []
    }
    
    init(
        friendService: FriendServiceProtocol,
        userService: UserServiceProtocol,
        userId: Int
    ) {
        self.friendService = friendService
        self.userService = userService
        self.model = Model(userId: userId)
        super.init()
    }
    
    override func bind() {
        self.input.fetch
            .subscribe(onNext: {
                self.fetchFriend()
                self.fetchFriendInfo(userId: self.model.userId)
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
        
        guard let friendId = model.friendId else { return }
        
        self.friendService.banFriend(friendId) {  response, error in
            guard let response = response else {
                return
            }
            
            if response.isSuccess {
                self.output.dismiss.accept(())
                self.showToastMessage.accept("친구 삭제 성공")
            } else {
                self.showErrorMessage.accept(response.message)
            }
        }
    }
    
    private func deleteFriend() {
        
        guard let friendId = model.friendId else { return }
        
        self.friendService.deleteFriend(friendId) {  response, error in
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
                
                self.model.friendInfo = Friend(id: -1,
                                           userId: userId,
                                           name: userInfo.name,
                                           code: userInfo.code,
                                           profileImage: userInfo.profileImage,
                                           state: .none)
                
                self.output.friendInfo.accept(self.model.friendInfo)
                
                self.model.friendList.forEach {
                    if($0.userId == self.model.userId) {
                        self.model.friendId = $0.id
                    }
                }
            }
        }
    }
    
    func fetchFriend() {
        self.friendService.fetchFriend { friends, _ in
            guard let friends = friends else {
                return
            }
            
            var friendList: [Friend] = []
            
            friends.forEach {
                let a = $0.items
                a.forEach {
                    switch $0 {
                    case .normal(let friend):
                        friendList.append(friend)
                    default: break
                    }}
            }
            
            
            self.model.friendList = friendList
        }
    }
}
