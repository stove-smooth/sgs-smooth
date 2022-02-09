//
//  ChannelService.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import Foundation
import Moya

protocol ChannelServiceProtocol {
    // MARK: POST
    func createChannel(request: ChannelRequest, _ completion: @escaping (Channel?, MoyaError?) -> Void)
    
    // MARK: PATCH
    func updateLocation(originId: Int, nextId: Int, categoryId: Int, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
}


struct ChannelService: Networkable, ChannelServiceProtocol {
    typealias Target = ChannelTarget
    
    func createChannel(request: ChannelRequest, _ completion: @escaping (Channel?, MoyaError?) -> Void){
        makeProvider().request(.createChannel(request: request)) { result in
            switch BaseResponse<Channel>.processResponse(result) {
            case .success(let response):
                guard let response = response else { return }
                return completion(response, nil)
                
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func updateLocation(originId: Int, nextId: Int, categoryId: Int, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.updateLocation(originId: originId, nextId: nextId, categoryId: categoryId)) { result in
            switch BaseResponse<DefaultResponse>.processJSONResponse(result) {
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
