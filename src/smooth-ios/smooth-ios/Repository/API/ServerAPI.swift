//
//  ServerAPI.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation
import Moya
import UIKit

enum ServerTarget {
    case fetchServer
    case getServerById(param: Int)
    case createServer(param: ServerRequest)
    case createInvitation(param: Int)
    case joinServer(param: String)
    case leaveServer(param: Int)
}

extension ServerTarget: BaseAPI, AccessTokenAuthorizable {
    
    var path: String {
        switch self {
        case .fetchServer:
            return "/community-server/community"
        case .getServerById(let serverId):
            return "/community-server/community/\(serverId)"
        case .createServer:
            return "/community-server/community"
        case .createInvitation:
            return "/community-server/community/invitation"
        case .joinServer:
            return "/community-server/community/member"
        case .leaveServer(let communityId):
            return "/community-server/community/\(communityId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchServer: return .get
        case .getServerById: return .get
        case .createServer: return .post
        case .createInvitation: return .post
        case .joinServer: return .post
        case .leaveServer: return .delete
        }
    }

    var task: Task {
        switch self {
        case .fetchServer:
            return .requestPlain
        case .getServerById:
            return .requestPlain
        case .createServer(let request):
            var multipartFromData: [MultipartFormData] = []
            if (request.icon != nil) {
                multipartFromData.append(
                    MultipartFormData(
                        provider: .data(request.icon!),
                        name: "icon",
                        fileName: "server-icon",
                        mimeType: request.icon!.mimeType
                    )
                )
            }
            
            let nameData = request.name.data(using: .utf8) ?? Data()
            let publicData = request.public.description.data(using: .utf8) ?? Data()
            
            multipartFromData.append(MultipartFormData(provider: .data(nameData), name: "name"))
            multipartFromData.append(MultipartFormData(provider: .data(publicData), name: "public"))
            
            print(multipartFromData)
            return .uploadMultipart(multipartFromData)
        case .createInvitation(let serverId):
            return .requestParameters(parameters: ["id": serverId], encoding: JSONEncoding.default)
        case .joinServer(let serverCode):
            return .requestParameters(parameters: ["code": serverCode], encoding: JSONEncoding.default)
        case .leaveServer:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .fetchServer:
            return .custom("")
        case .getServerById:
            return .custom("")
        case .createServer:
            return .custom("")
        case .createInvitation:
            return .custom("")
        case .joinServer:
            return .custom("")
        case .leaveServer:
            return .custom("")
        }
    }
}
