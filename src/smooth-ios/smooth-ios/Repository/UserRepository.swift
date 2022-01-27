//
//  UserRepository.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya

protocol UserRepositoryProtocol {
    func signIn(_ request: SignInRequest, _ completion: @escaping (SignInResponse?, Error?) -> Void )
    func signUp(_ request: SignUpRequest, _ completion: @escaping (SignUpResponse?, Error?) -> Void )
    func sendMail(_ request: SendMailRequest, _ completion: @escaping (SendMailResponse?, Error?) -> Void)
    func checkEmail(_ request: VerifyCodeRequest, _ completion: @escaping (VerifyCodeResponse?, Error?) -> Void)
    func fetchUserInfo(_ completion: @escaping (User?, Error?) -> Void)
}

struct UserRepository: Networkable, UserRepositoryProtocol {
    typealias Target = UserTarget
    
    func signIn(_ request: SignInRequest, _ completion: @escaping (SignInResponse?, Error?) -> Void ) {
        makeProvider().request(.signIn(param: request)) { result in
            switch BaseResponse<SignInResponse>.processJSONResponse(result) {
            case .success(let response):
                guard let response = response else {
                    return
                }
                return completion(response, nil)
            case .failure(let error):
                print("🆘 error! \(error)")
                return completion(nil, error)
            }
        }
    }
    
    func signUp(_ request: SignUpRequest, _ completion: @escaping (SignUpResponse?, Error?) -> Void ) {
        makeProvider().request(.signUp(param: request)) { result in
            switch BaseResponse<SignUpResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    
    func sendMail(_ request: SendMailRequest, _ completion: @escaping (SendMailResponse?, Error?) -> Void) {
        makeProvider().request(.sendMail(param: request)) { result in
            switch BaseResponse<SendMailResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func checkEmail(_ request: VerifyCodeRequest, _ completion: @escaping (VerifyCodeResponse?, Error?) -> Void) {
        makeProvider().request(.verifyCode(param: request)) { result in
            switch BaseResponse<VerifyCodeResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func fetchUserInfo(_ completion: @escaping (User?, Error?) -> Void) {
        makeProvider().request(.fetchUserInfo) { result in
            switch BaseResponse<User>.processResponse(result) {
            case .success(let response):
                guard let response = response else {
                    return
                }

                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
}

