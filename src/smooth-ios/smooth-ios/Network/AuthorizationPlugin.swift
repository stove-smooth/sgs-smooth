//
//  Endpoint.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import Foundation
import Moya

enum AuthTokenType {
    case access
    case none
}

struct AuthPlugin: PluginType {
    //  let tokenStorage: TokenStorageServiceProtocol
      
      func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? SecuredEndpoint else {
          return request
        }
        
        let neededToken: String?

        switch target.requiredAuthTokenType {
        case .access:
          neededToken = "tokenStorage.getLastPibbleTargetAccessToken()"
//        case .signUpToken:
//          neededToken = "tokenStorage.getLastPibbleTargetSignUpToken()"
//        case .refreshAccessToken:
//          neededToken = "tokenStorage.getLastPibbleTargetRefreshToken()"
//        case .refreshSignUpToken:
//          neededToken = "tokenStorage.getLastPibbleTargetSignUpRefreshToken()"
        case .none:
          neededToken = nil
          return request
        }
        
        guard let token = neededToken else {
          return request
        }
        
        var request = request
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
      }
}
