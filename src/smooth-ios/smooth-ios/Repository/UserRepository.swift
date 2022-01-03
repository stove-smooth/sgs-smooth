//
//  UserRepository.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya

class UserRepository: BaseRepository<UserAPI> {
    static let shared = UserRepository()
    
    private override init() { }
    
    func signIn(_ request: SignInRequest, _ completion: @escaping (SignInResponse?, Error?) -> Void ) {
        rx.request(.signIn(param: request))
            .filterSuccessfulStatusCodes()
            .map(SignInResponse.self, atKeyPath: "result")
            .debug()
            .subscribe(onSuccess: {
                completion($0, nil)
            }, onFailure: {
                completion(nil, $0)
            })
            .disposed(by: disposeBag)
    }
    
    func signUp(_ request: SignUpRequest, _ completion: @escaping (SignUpResponse?, Error?) -> Void ) {
        rx.request(.signUp(param: request))
            .filterSuccessfulStatusCodes()
            .map(SignUpResponse.self)
            .subscribe(onSuccess: {
                print($0)
                completion($0, nil)
            }, onFailure: {
                completion(nil, $0)
            })
            .disposed(by: disposeBag)
    }
}
 
