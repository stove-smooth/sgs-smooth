//
//  UserRepository.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya

class UserRepository: BaseRepository<UserTarget>, Networkable {
    typealias Target = UserTarget
    
    static let shared = UserRepository()
    
    
    let provider: MoyaProvider<UserTarget> = makeProvider()
    
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
    
    
    func sendMail(_ request: SendMailRequest, _ completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(.sendMail(param: request)) { result in
            switch result {
            case .success(let res):
                print(res)
            case .failure(let res):
                print(res)
                
            }
        }
//        rx.request(.sendMail(param: request))
//            .debug()
//            .filterSuccessfulStatusCodes()
//            .map(SendMailResponse.self, atKeyPath: "result")
//            .debug()
//            .subscribe(onSuccess: {
//                completion($0, nil)
//            }, onFailure: {
//                completion(nil, $0)
//            })
//            .disposed(by: disposeBag)
    }
}
 
