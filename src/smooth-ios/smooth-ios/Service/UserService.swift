//
//  UserService.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import Alamofire
import RxSwift

//protocol UserServiceProtocol{
//    func signIn(request: SignInRequest) -> Single<SigninResponse>
//    func signup(request: SignupRequest) -> Single<SigninResponse>
//    func fetchUserInfo() -> Single<User>
//}
//
//struct UserSerivce: UserServiceProtocol {
//
//    private let userRepository: UserRepository
//
//    init(userRepository: UserRepository) {
//        self.userRepository = userRepository
//    }
//
//    func signIn(request: SignInRequest) -> Single<SigninResponse> {
//        return userRepository.signIn(request) { _, _ in
//            print("signIn")
//        }
//    }
//
//    func signup(request: SignupRequest) -> Single<SigninResponse> {
//
//    }
//
//    func fetchUserInfo() -> Single<User> {
//
//    }
//
//    func signup(request: SignupRequest) -> Observable<SigninResponse> {
//        return Observable.create { obs in
//            let url = HTTPUtils.url + "/users/signup"
//
//            HTTPUtils.defaultSession.request(
//              url,
//              method: .post,
//                parameters: request.paramters,
//              encoding: JSONEncoding.default,
//              headers: HTTPUtils.jsonWithTokenHeader()
//            ).responseJSON { response in
//                switch response.result {
//                case .success(let value):
//
//                    let json = JsonUtils.toJson(of: SigninResponse.self, object: value)
//
//                    obs.onNext(json!)
//                    obs.onCompleted()
//                default:
//                    return
//                }
//            }
//
//            return Disposables.create()
//        }
//    }
//
//    func signIn(request: SignInRequest) -> Observable<SigninResponse> {
//        return Observable.create { obs -> Disposable in
//            let url = HTTPUtils.url + "/users/login"
//
//            HTTPUtils.defaultSession.request(
//                url,
//                method: .post,
//                parameters: request.paramters,
//                encoding: JSONEncoding.default,
//                headers: HTTPUtils.jsonHeader()
//            ).responseJSON { response in
//                switch response.result {
//                case .success(let value):
//
//                    guard let json = JsonUtils.toJson(of: SigninResponse.self, object: value) else {
//                        return
//                    }
//
//                    obs.onNext(json)
//                    obs.onCompleted()
//                default:
//                    return
//                }
//            }
//
//            return Disposables.create()
//        }
//    }
//
//    func fetchUserInfo() -> Observable<User> {
//        return Observable.create { obs -> Disposable in
//            let url = HTTPUtils.url + "/users/me"
//            let headers = HTTPUtils.defaultHeader()
//
//            HTTPUtils.defaultSession.request(
//                url,
//                method: .get,
//                headers: headers
//            ).responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    guard let json = JsonUtils.toJson(of: User.self, object: value) else {
//                        return
//                    }
//                    obs.onNext(json)
//                    obs.onCompleted()
//                default:
//                    return
//                }
//            }
//            return Disposables.create()
//        }
//    }
//}

