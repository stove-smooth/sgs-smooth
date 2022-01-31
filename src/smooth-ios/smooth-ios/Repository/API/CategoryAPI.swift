//
//  CategoryAPI.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import Foundation
import Moya

enum CategoryTarget {
    // MARK: POST
    case createCategory(request: CategoryReqeust)
}

extension CategoryTarget: BaseAPI, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .createCategory:
            return "/community-server/category"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createCategory: return .post
        }
    }
    
    var task: Task {
        switch self {
        case .createCategory(let request):
            return .requestCustomJSONEncodable(request, encoder: JSONEncoder())
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .createCategory:
            return .custom("")
        }
    }
}
