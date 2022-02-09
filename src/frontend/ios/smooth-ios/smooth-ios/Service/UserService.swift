//
//  UserService.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya

protocol UserServiceProtocol {
    // MARK: POST
    func signIn(email: String, password: String, _ completion: @escaping (SignIn?, MoyaError?) -> Void)
    func signUp(_ request: SignUpRequest, _ completion: @escaping (SignUpResponse?, MoyaError?) -> Void )
    func sendMail(_ request: SendMailRequest, _ completion: @escaping (SendMailResponse?, MoyaError?) -> Void)
    
    // MARK: GET
    func checkEmail(_ request: VerifyCodeRequest, _ completion: @escaping (VerifyCodeResponse?, MoyaError?) -> Void)
    func fetchUserInfo(_ completion: @escaping (User?, MoyaError?) -> Void)
    func fetchUserInfoById(userId: Int, _ completion: @escaping (UserInfo?, MoyaError?) -> Void)
}

struct UserService: Networkable, UserServiceProtocol {
    typealias Target = UserTarget
    
    func signIn(email: String, password: String, _ completion: @escaping (SignIn?, MoyaError?) -> Void) {
        makeProvider().request(.signIn(email: email, password: password)) { result in
            switch BaseResponse<SignIn>.processCommonResponse(result) {
            case .success(let response):
                guard let response = response else {
                    return
                }
                return completion(response.result, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func signUp(_ request: SignUpRequest, _ completion: @escaping (SignUpResponse?, MoyaError?) -> Void ) {
        makeProvider().request(.signUp(param: request)) { result in
            switch BaseResponse<SignUpResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    
    func sendMail(_ request: SendMailRequest, _ completion: @escaping (SendMailResponse?, MoyaError?) -> Void) {
        makeProvider().request(.sendMail(param: request)) { result in
            switch BaseResponse<SendMailResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func checkEmail(_ request: VerifyCodeRequest, _ completion: @escaping (VerifyCodeResponse?, MoyaError?) -> Void) {
        makeProvider().request(.verifyCode(param: request)) { result in
            switch BaseResponse<VerifyCodeResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func fetchUserInfo(_ completion: @escaping (User?, MoyaError?) -> Void) {
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
    
    func fetchUserInfoById(userId: Int, _ completion: @escaping (UserInfo?, MoyaError?) -> Void) {
        makeProvider().request(.fetchUserInfoById(userId: userId)) {
            result in
            switch BaseResponse<UserInfo>.processResponse(result) {
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

