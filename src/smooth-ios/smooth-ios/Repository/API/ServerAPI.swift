//
//  ServerAPI.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation
import Moya

enum ServerTarget {
    case fetchServer
    case getServerById(param: Int)
    case createServer(param: ServerRequest)
    case createInvitation
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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchServer: return .get
        case .getServerById: return .get
        case .createServer: return .post
        case .createInvitation: return .post
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
        case .createInvitation:
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
        }
    }
}
