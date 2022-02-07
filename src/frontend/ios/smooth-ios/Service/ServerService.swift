//
//  ServerService.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation
import Moya
import RxSwift

protocol ServerServiceProtocol {
    // MARK: GET
    func fetchServer(_ completion: @escaping ([Server]?, MoyaError?) -> Void)
    func getServerById(_ request: Int, _ completion: @escaping (CommunityInfo?, MoyaError?) -> Void)
    func getMemberFromServer(_ serverId: Int, _ completion: @escaping ([Member]?, MoyaError?) -> Void)
    func getInvitByServer(_ serverId: Int, _ completion: @escaping ([Invitation]?, MoyaError?) -> Void)
    
    // MARK: POST
    func createServer(_ request: ServerRequest, _ completion: @escaping (Server?, MoyaError?) -> Void)
    func createInvitation(_ serverId: Int, _ completion: @escaping (String?, MoyaError?) -> Void)
    func joinServer(_ serverCode: String, _ completion: @escaping (Server?, MoyaError?) -> Void)
    
    // MARK: PATCH
    func updateServerIcon(serverId: Int, imageData: Data?, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
    func updateServerName(serverId: Int, name: String, _  completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
    
    
    // MARK: DELETE
    func leaveServer(serverId: Int, memberId: Int, _  completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
    func deleteServer(_ serverId: Int, _  completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
    func deleteinvitation(_ invitationId: Int, _  completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
}

struct ServerService: Networkable, ServerServiceProtocol {
    typealias Target = ServerTarget
    
    func fetchServer(_ completion: @escaping ([Server]?, MoyaError?) -> Void) {
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
    
    func getServerById(_ request: Int, _ completion: @escaping (CommunityInfo?, MoyaError?) -> Void) {
        makeProvider().request(.getServerById(param: request)) { result in
            switch BaseResponse<CommunityInfo>.processResponse(result) {
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
    
    func getMemberFromServer(_ serverId: Int, _ completion: @escaping ([Member]?, MoyaError?) -> Void) {
        makeProvider().request(.getMemberFromServer(param: serverId)) { result in
            switch BaseResponse<MemberList>.processResponse(result) {
            case .success(let response):
                guard let response = response else {
                    return
                }
                
                return completion(response.members, nil)
            
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func getInvitByServer(_ serverId: Int, _ completion: @escaping ([Invitation]?, MoyaError?) -> Void) {
        makeProvider().request(.getInvitByServer(serverId: serverId)) { result in
            switch BaseResponse<InvitaionList>.processResponse(result) {
            case .success(let response):
                guard let response = response else {
                    return
                }
                
                return completion(response.invitations, nil)
            
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func createServer(_ request: ServerRequest, _ completion: @escaping (Server?, MoyaError?) -> Void) {
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
    
    func createInvitation(_ serverId: Int, _ completion: @escaping (String?, MoyaError?) -> Void) {
        makeProvider().request(.createInvitation(param: serverId)) { result in
            switch BaseResponse<InvitationResponse>.processResponse(result) {
            case .success(let response):
                guard let response = response else {
                    return
                }
                
                return completion(response.url, nil)
            case .failure(let error):
                return completion(nil, error)
            }
        }
    }
    
    func joinServer(_ serverCode: String, _ completion: @escaping (Server?, MoyaError?) -> Void) {
        makeProvider().request(.joinServer(param: serverCode)) { result in
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
    
    func updateServerIcon(serverId: Int, imageData: Data?, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.updateServerIcon(serverId: serverId, imageData: imageData)) {
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
    
    func updateServerName(serverId: Int, name: String, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.updateServerName(serverId: serverId, name: name)) {
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

    func leaveServer(serverId: Int, memberId: Int, _  completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.leaveServer(serverId: serverId, memberId: memberId)) { result in
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
    
    func deleteServer(_ serverId: Int,  _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.deleteServer(serverId: serverId)) { result in
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
    
    func deleteinvitation(_ invitationId: Int, _  completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.deleteinvitation(invitationId: invitationId)) { result in
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