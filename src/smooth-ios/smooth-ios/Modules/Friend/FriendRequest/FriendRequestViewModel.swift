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
    
    
    struct Input {
        let userTextField = BehaviorRelay<String>(value: "")
        let tapRequestButton = PublishSubject<Void>()
    }
    
    struct Output {
        let dismiss = PublishRelay<Void>()
    }
    
    override func bind() {
        self.input.userTextField
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
            
        self.input.tapRequestButton
            .subscribe(onNext: {
                let requestList = self.input.userTextField.value.components(separatedBy: "#")
                print("\(requestList[0]) \(requestList[1])")
                
                FriendRepository.requestFriend(RequestFriend(name: requestList[0], code: requestList[1])) { response, error in
                    if (error != nil) {
                        print("실패 얼럿 \(error)")
                    } else {
                        print("요청 성공 얼럿 띄우기")
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
}

