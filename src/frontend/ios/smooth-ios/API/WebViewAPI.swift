//
//  WebViewAPI.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/14.
//

import Foundation
import Moya

enum WebViewTarget {
    case webRTC(serverId: Int, channelId: Int)
}

extension WebViewTarget: BaseAPI, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .webRTC:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .webRTC(let serverId, let channelId):
            return "/m/\(serverId)/\(channelId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .webRTC:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .webRTC:
            let user = UserDefaultsUtil().getUserInfo()
            let token = UserDefaultsUtil().getUserToken()
            
            return .requestParameters(parameters: [
                "userId": "\(user!.id)",
                "accessToken": token
            ], encoding: URLEncoding.queryString)
        }
    }
    
    
}
