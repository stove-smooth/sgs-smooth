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
    
    // MARK: PATCH
    case updateCategoryName(categoryId: Int, name: String)
    
    // MARK: PATCH
    case deleteCategory(categoryId: Int)
}

extension CategoryTarget: BaseAPI, AccessTokenAuthorizable {
    var path: String {
        switch self {
        case .createCategory:
            return "/community-server/category"
        case .updateCategoryName:
            return "/community-server/category/name"
        case .deleteCategory(let categoryId):
            return "/community-server/category/\(categoryId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createCategory: return .post
        case .updateCategoryName: return .patch
        case .deleteCategory: return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .createCategory(let request):
            return .requestCustomJSONEncodable(request, encoder: JSONEncoder())
        case .updateCategoryName(let categoryId, let name):
            return .requestParameters(parameters: ["id": categoryId, "name": name], encoding: JSONEncoding.default)
        case .deleteCategory:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .createCategory:
            return .custom("")
        case .updateCategoryName:
            return .custom("")
        case .deleteCategory:
            return .custom("")
        }
    }
}
