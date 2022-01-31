//
//  ChannelRepository.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import Foundation
import Moya

protocol ChannelRepositoryProtocol {
    func createChannel(categoryId: Int, channel: Channel, _ completion: @escaping (Channel?, MoyaError?) -> Void)
}


struct ChannelRepository: Networkable, ChannelRepositoryProtocol {
    typealias Target = ChannelTarget
    
    func createChannel(categoryId: Int, channel: Channel, _ completion: @escaping (Channel?, MoyaError?) -> Void){
        makeProvider().request(.createChannel(categoryId: categoryId, channel: channel)) { result in
            switch BaseResponse<Channel>.processResponse(result) {
            case .success(let response):
                guard let response = response else { return }
                return completion(response, nil)
                
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
}
