//
//  ChattingService.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import Foundation
import Moya

protocol ChattingServiceProtocol {
    func fetchMessgae(_ channelId: Int, completion: @escaping ([Message]?, MoyaError?) -> Void)
}


struct ChattingService: Networkable, ChattingServiceProtocol {
    typealias Target = ChattingTarget
    
    func fetchMessgae(_ channelId: Int, completion: @escaping ([Message]?, MoyaError?) -> Void) {
        makeProvider().request(.fetchMessgae(channelId: channelId)) {
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
}
