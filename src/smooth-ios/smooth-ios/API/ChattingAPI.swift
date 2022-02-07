//
//  ChattingAPI.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import Foundation
import Moya

enum ChattingTarget {
    // MARK: - GET
    case fetchMessgae(channelId: Int, page: Int, size: Int)
    
    // MARK: - POST
    case sendFileMessage(request: FileMessageRequest)
    
}

extension ChattingTarget: BaseAPI, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .fetchMessgae:
            return "/chat-server/community"
        case .sendFileMessage:
            return "/chat-server/channel/file"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchMessgae: return .get
        case .sendFileMessage: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchMessgae(let channelId, let page, let size):
            return .requestParameters(parameters: [
                "ch_id": channelId,
                "page": page,
                "size": size
            ], encoding: URLEncoding.queryString)
        case .sendFileMessage(let request):
            var multipartFromData: [MultipartFormData] = []
            
            multipartFromData.append(
                MultipartFormData(
                    provider: .data(request.image!),
                    name: "image",
                    fileName: "messgae-image-\(String(describing: request.communityId))-\(request.userId)",
                    mimeType: request.image!.mimeType
                )
            )
            
            multipartFromData.append(
                MultipartFormData(
                    provider: .data(request.thumbnail!),
                    name: "thumbnail",
                    fileName: "messgae-thumbnail-\(String(describing: request.communityId))-\(request.userId)",
                    mimeType: request.image!.mimeType
                )
            )
            
            let userId = request.userId.description.data(using: .utf8) ?? Data()
            let channelId = request.channelId.description.data(using: .utf8) ?? Data()
            let type = request.type.description.data(using: .utf8) ?? Data()
            let fileType = request.fileType.rawValue.description.data(using: .utf8) ?? Data()
            
            multipartFromData.append(MultipartFormData(provider: .data(userId), name: "userId"))
            multipartFromData.append(MultipartFormData(provider: .data(channelId), name: "channelId"))
            multipartFromData.append(MultipartFormData(provider: .data(type), name: "type"))
            multipartFromData.append(MultipartFormData(provider: .data(fileType), name: "fileType"))
            
            if (request.communityId != nil) {
                let communityId = request.communityId!.description.data(using: .utf8) ?? Data()
                multipartFromData.append(MultipartFormData(provider: .data(communityId), name: "communityId"))
            }
            
            return .uploadMultipart(multipartFromData)
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .fetchMessgae:
            return .none
        case .sendFileMessage:
            return .custom("")
        }
    }
}
