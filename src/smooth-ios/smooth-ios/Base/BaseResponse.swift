//
//  BaseResponse.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/03.
//

import Foundation
import Moya

struct DefaultResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}

struct BaseResponse<Model: Codable>{
    struct CommonResponse: Codable {
        let result: Model
    }
    
    static func processResponse(_ result: Result<Response, MoyaError>) -> Result<Model?, Error> {
        switch result {
        case .success(let response):
            do {
                _ = try response.filterSuccessfulStatusCodes()
                
                let commonResponse = try JSONDecoder().decode(CommonResponse.self, from: response.data)
                return .success(commonResponse.result)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func processJSONResponse(_ result: Result<Response, MoyaError>) -> Result<Model?, Error> {
        switch result {
        case .success(let response):
            do {
                let model = try JSONDecoder().decode(Model.self, from: response.data)
                return .success(model)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
