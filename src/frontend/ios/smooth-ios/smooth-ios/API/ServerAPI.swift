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
    // MARK: GET
    case fetchServer
    case getServerById(param: Int)
    case getMemberFromServer(param: Int)
    case getInvitByServer(serverId: Int)
    
    // MARK: POST
    case createServer(param: ServerRequest)
    case createInvitation(param: Int)
    case joinServer(param: String)
    
    // MARK: PATCH
    case updateServerIcon(serverId: Int, imageData: Data?)
    case updateServerName(serverId: Int, name: String)
    
    // MARK: DELETE
    case leaveServer(serverId: Int, memberId: Int)
    case deleteServer(serverId: Int)
    case deleteinvitation(invitationId: Int)
}

extension ServerTarget: BaseAPI, AccessTokenAuthorizable {
    
    var path: String {
        switch self {
        case .fetchServer:
            return "/community-server/community"
        case .getServerById(let serverId):
            return "/community-server/community/\(serverId)"
        case .getMemberFromServer(let serverId):
            return "/community-server/community/\(serverId)/member"
        case .getInvitByServer(let serverId):
            return "/community-server/community/\(serverId)/invitation"
            
        case .createServer:
            return "/community-server/community"
        case .createInvitation:
            return "/community-server/community/invitation"
        case .joinServer:
            return "/community-server/community/member"
            
        case .updateServerIcon:
            return "/community-server/community/icon"
        case .updateServerName:
            return "/community-server/community/name"
            
        case .leaveServer(let serverId, _):
            return "/community-server/community/\(serverId)/member"
        case .deleteServer(let serverId):
            return "/community-server/community/\(serverId)"
        case .deleteinvitation:
            return "/community-server/community/invitation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchServer: return .get
        case .getServerById: return .get
        case .getMemberFromServer: return .get
        case .getInvitByServer: return .get
            
        case .createServer: return .post
        case .createInvitation: return .post
        case .joinServer: return .post
            
        case .updateServerIcon: return .patch
        case .updateServerName: return .patch
            
        case .leaveServer: return .delete
        case .deleteServer: return .delete
        case .deleteinvitation: return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .fetchServer:
            return .requestPlain
        case .getServerById:
            return .requestPlain
        case .getMemberFromServer(let memberId):
            return .requestParameters(parameters: ["id": memberId], encoding: URLEncoding.queryString)
        case .getInvitByServer:
            return .requestPlain
            
        case .createServer(let request):
            var multipartFromData: [MultipartFormData] = []
            if (request.icon != nil) {
                multipartFromData.append(
                    MultipartFormData(
                        provider: .data(request.icon!),
                        name: "icon",
                        fileName: "server-icon-\(Data())",
                        mimeType: request.icon!.mimeType
                    )
                )
            }
            
            let nameData = request.name.data(using: .utf8) ?? Data()
            let publicData = request.public.description.data(using: .utf8) ?? Data()
            
            multipartFromData.append(MultipartFormData(provider: .data(nameData), name: "name"))
            multipartFromData.append(MultipartFormData(provider: .data(publicData), name: "public"))
            
            return .uploadMultipart(multipartFromData)
        case .createInvitation(let serverId):
            return .requestParameters(parameters: ["id": serverId], encoding: JSONEncoding.default)
        case .joinServer(let serverCode):
            return .requestParameters(parameters: ["code": serverCode], encoding: JSONEncoding.default)
        
        case .updateServerIcon(let serverId, let imgData):
            var multipartFromData: [MultipartFormData] = []
            
            let idData = serverId.description.data(using: .utf8) ?? Data()
            multipartFromData.append(MultipartFormData(provider: .data(idData), name: "id"))
            
            if (imgData != nil) {
                multipartFromData.append(
                    MultipartFormData(
                        provider: .data(imgData!),
                        name: "icon",
                        fileName: "new-server-icon",
                        mimeType: imgData!.mimeType
                    )
                )
            }
           
            return .uploadMultipart(multipartFromData)
            
        case .updateServerName(let serverId, let name):
            return .requestParameters(
                parameters: ["id": serverId, "name" : name],
                encoding: JSONEncoding.default)
            
        case .leaveServer(_, let memberId):
            return .requestParameters(parameters: ["id": memberId], encoding: URLEncoding.queryString)
        case .deleteServer:
            return .requestPlain
        case .deleteinvitation(let invitationId):
            return .requestParameters(parameters: ["id": invitationId], encoding: URLEncoding.queryString)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .fetchServer:
            return .custom("")
        case .getServerById:
            return .custom("")
        case .getMemberFromServer:
            return .custom("")
        case .getInvitByServer:
            return .custom("")
            
        case .createServer:
            return .custom("")
        case .createInvitation:
            return .custom("")
        case .joinServer:
            return .custom("")
            
        case .updateServerIcon:
            return .custom("")
        case .updateServerName:
            return .custom("")
            
        case .leaveServer:
            return .custom("")
        case .deleteServer:
            return .custom("")
        case .deleteinvitation:
            return .custom("")
        }
    }
}
