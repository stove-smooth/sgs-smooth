//
//  ServerRepository.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation
import Moya
import RxSwift

protocol ServerRepositoryProtocol {
    func fetchServer(_ completion: @escaping ([Server]?, Error?) -> Void)
    func getServerById(_ request: Int, _ completion: @escaping (CommunityResponse?, Error?) -> Void)
    func createServer(_ request: ServerRequest, _ completion: @escaping (Server?, Error?) -> Void)
}

struct ServerRepository: Networkable, ServerRepositoryProtocol {
    typealias Target = ServerTarget
    
    func fetchServer(_ completion: @escaping ([Server]?, Error?) -> Void) {
        makeProvider().request(.fetchServer) { result in
            switch BaseResponse<Community>.processResponse(result) {
            case .success(let response):
                guard let response = response else {
                    return
                }
                return completion(response.communities, nil)
            
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func getServerById(_ request: Int, _ completion: @escaping (CommunityResponse?, Error?) -> Void) {
        makeProvider().request(.getServerById(param: request)) { result in
            switch BaseResponse<CommunityResponse>.processResponse(result) {
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
    
    func createServer(_ request: ServerRequest, _ completion: @escaping (Server?, Error?) -> Void) {
        makeProvider().request(.createServer(param: request)) { result in
            switch BaseResponse<Server>.processResponse(result) {
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
