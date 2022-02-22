//
//  ChattingService.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import Foundation
import Moya

protocol ChattingServiceProtocol {
    func fetchMessgaeByCommunity(_ channelId: Int, page: Int, size: Int, _ completion: @escaping ([Message]?, MoyaError?) -> Void)
    func fetchMessgaeByDirect(_ channelId: Int, page: Int, size: Int, _ completion: @escaping ([Message]?, MoyaError?) -> Void)
    func sendFileMessage(_ request: FileMessageRequest, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
}


struct ChattingService: Networkable, ChattingServiceProtocol {
    typealias Target = ChattingTarget
    
    func fetchMessgaeByCommunity(_ channelId: Int, page: Int, size: Int, _ completion: @escaping ([Message]?, MoyaError?) -> Void) {
        makeProvider().request(.fetchMessgaeByCommunity(channelId: channelId, page: page, size: size)) {
            result in
            switch BaseResponse<[Message]>.processResponse(result) {
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
    
    func fetchMessgaeByDirect(_ channelId: Int, page: Int, size: Int, _ completion: @escaping ([Message]?, MoyaError?) -> Void) {
        makeProvider().request(.fetchMessgaeByDirect(channelId: channelId, page: page, size: size)) {
            result in
            switch BaseResponse<[Message]>.processResponse(result) {
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
    
    func sendFileMessage(_ request: FileMessageRequest, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.sendFileMessage(request: request)) {
            result in
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
