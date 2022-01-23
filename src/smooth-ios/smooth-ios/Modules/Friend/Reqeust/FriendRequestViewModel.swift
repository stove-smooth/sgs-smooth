//
//  FriendRequestViewModel.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import RxSwift
import RxCocoa

class FriendRequestViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let friendRepository: FriendRepositoryProtocol
    
    struct Input {
        let userTextField = BehaviorRelay<String>(value: "")
        let tapRequestButton = PublishSubject<Void>()
    }
    
    struct Output {
        let dismiss = PublishRelay<Void>()
    }
    
    init(
        friendRepository: FriendRepositoryProtocol
    ) {
        self.friendRepository = friendRepository
        super.init()
    }
    
    override func bind() {
        self.input.userTextField
            .subscribe(onNext: {
                // TODO: 정규식(닉네임#코드(4자리))
                print($0)
            })
            .disposed(by: disposeBag)
        
        self.input.tapRequestButton
            .subscribe(onNext: {
                let requestList = self.input.userTextField.value.components(separatedBy: "#")
                
                self.friendRepository.requestFriend(RequestFriend(name: requestList[0], code: requestList[1])) { response, _ in
                    
                    guard let response = response else {
                        return
                    }
                    
                    if (response.isSuccess) {
                        self.showToastMessage.accept("친구 요청 완료")
                    } else {
                        self.showErrorMessage.accept(response.message)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

