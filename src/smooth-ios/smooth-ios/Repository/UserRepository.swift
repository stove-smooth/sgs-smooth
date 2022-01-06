//
//  UserRepository.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya
import RxSwift

struct UserRepository: Networkable {
    let disposeBag = DisposeBag()
    
    typealias Target = UserTarget
    
    static func signIn(_ request: SignInRequest, _ completion: @escaping (SignInResponse?, Error?) -> Void ) {
        makeProvider().request(.signIn(param: request)) { result in
            switch BaseResponse<SignInResponse>.processJSONResponse(result) {
            case .success(let response):
                guard let response = response else {
                    return
                }
                
                UserDefaultsUtil.setUserToken(token: response.result.accessToken)
                return completion(response, nil)
            case .failure(let error):
                print("🆘 error! \(error)")
                return completion(nil, error)
            }
        }
//        provider.rx.request(.signIn(param: request))
//            .filterSuccessfulStatusCodes()
//            .map(SignInResponse.self, atKeyPath: "result")
//            .debug()
//            .subscribe(onSuccess: {
//                completion($0, nil)
//            }, onFailure: {
//                completion(nil, $0)
//            })
//            .disposed(by: disposeBag)
    }
    
    static func signUp(_ request: SignUpRequest, _ completion: @escaping (SignUpResponse?, Error?) -> Void ) {
        makeProvider().request(.signUp(param: request)) { result in
            switch BaseResponse<SignUpResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    
    static func sendMail(_ request: SendMailRequest, _ completion: @escaping (SendMailResponse?, Error?) -> Void) {
        makeProvider().request(.sendMail(param: request)) { result in
            switch BaseResponse<SendMailResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    static func checkEmail(_ request: VerifyCodeRequest, _ completion: @escaping (VerifyCodeResponse?, Error?) -> Void) {
        makeProvider().request(.verifyCode(param: request)) { result in
            switch BaseResponse<VerifyCodeResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    static func fetchUserInfo(_ completion: @escaping (User?, Error?) -> Void) {
        makeProvider().request(.fetchUserInfo) { result in
            switch BaseResponse<User>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
}
 
