//
//  FriendRepository.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import Foundation
import Moya
import RxSwift

protocol FriendRepositoryProtocol {
    func fetchFriend(_ completion: @escaping ([FriendSection]?, Error?) -> Void)
    func deleteFriend(_ request: Int, _ completion: @escaping (DefaultResponse?, Error?) -> Void)
    func requestFriend(_ request: RequestFriend, _ completion: @escaping (DefaultResponse?, Error?) -> Void)
    func banFriend(_ request: Int, _ completion: @escaping (DefaultResponse?, Error?) -> Void)
    func acceptFriend(_ request: Int, _ completion: @escaping (DefaultResponse?, Error?) -> Void)
}

struct FriendRepository: Networkable, FriendRepositoryProtocol {
    let disposeBag = DisposeBag()
    
    typealias Target = FriendTarget
    
    func fetchFriend(_ completion: @escaping ([FriendSection]?, Error?) -> Void) {
        makeProvider().request(.fetchFriend) { result in
            switch BaseResponse<FriendListResponse>.processJSONResponse(result) {
            case .success(let responses):
                guard let responses = responses else { return }
                
                var section: [FriendSection] = []
                
                // TODO: 하드코딩한거 리팩토링 해야함
                let friendList = responses.result
                    .filter { $0.state == .accept }
                    .map { FriendCellType.normal($0) }
                
                if friendList.count > 0 {
                    section.append(FriendSection(header: "친구", items: friendList))
                }
                
                let waitList = responses.result
                    .filter { $0.state == .wait || $0.state == .request }
                    .map { FriendCellType.normal($0) }
                
                if waitList.count > 0 {
                    section.append(FriendSection(header: "수락 대기 중", items: waitList))
                }
                
                let banList = responses.result
                    .filter { $0.state == .ban }
                    .map { FriendCellType.normal($0) }
                
                if banList.count > 0 {
                    section.append(FriendSection(header: "차단", items: banList))
                }
                
                return completion(section, nil)
                
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
     func deleteFriend(_ request: Int, _ completion: @escaping (DefaultResponse?, Error?) -> Void) {
        makeProvider().request(.deleteFriend(param: request)) { result in
            switch BaseResponse<DefaultResponse>.processJSONResponse(result) {
            case .success(let responses):
                return completion(responses, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
     func requestFriend(_ request: RequestFriend, _ completion: @escaping (DefaultResponse?, Error?) -> Void) {
        makeProvider().request(.requestFriend(param: request)) { result in
            switch BaseResponse<DefaultResponse>.processJSONResponse(result) {
            case .success(let response):
                return completion(response, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func banFriend(_ request: Int, _ completion: @escaping (DefaultResponse?, Error?) -> Void) {
        makeProvider().request(.banFriend(param: request)) { result in
            switch BaseResponse<DefaultResponse>.processJSONResponse(result) {
            case .success(let responses):
                return completion(responses, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func acceptFriend(_ request: Int, _ completion: @escaping (DefaultResponse?, Error?) -> Void) {
        makeProvider().request(.acceptFriend(param: request)) { result in
            switch BaseResponse<DefaultResponse>.processJSONResponse(result) {
            case .success(let responses):
                return completion(responses, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
}
