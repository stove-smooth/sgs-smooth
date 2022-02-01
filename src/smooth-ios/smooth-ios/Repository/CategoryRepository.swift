//
//  CategoryRepository.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import Foundation
import Moya

protocol CategoryRepositoryProtocol {
    // MARK: POST
    func createCategory(request: CategoryReqeust, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
    
    // MARK: PATCH
    func updateCategoryName(categoryId: Int, name: String, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
    func updateLocation(originId: Int, nextId: Int, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
    
    // MARK: PATCH
    func deleteCategory(categoryId: Int, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void)
}

struct CategoryRepository: Networkable, CategoryRepositoryProtocol {
    typealias Target = CategoryTarget
    
    func createCategory(request: CategoryReqeust, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.createCategory(request: request)) {
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
    
    func updateCategoryName(categoryId: Int, name: String, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.updateCategoryName(categoryId: categoryId, name: name)) { result in
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
    
    func updateLocation(originId: Int, nextId: Int, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.updateLocation(originId: originId, nextId: nextId)) { result in
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
    
    func deleteCategory(categoryId: Int, _ completion: @escaping (DefaultResponse?, MoyaError?) -> Void) {
        makeProvider().request(.deleteCategory(categoryId: categoryId)) { result in
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
