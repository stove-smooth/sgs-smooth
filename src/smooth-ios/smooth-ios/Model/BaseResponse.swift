//
//  BaseResponse.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/03.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: T
}
