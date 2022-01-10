//
//  BaseAPI.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/03.
//

import Foundation
import Moya

protocol BaseAPI: TargetType {}

extension BaseAPI {
    var baseURL: URL { URL(string: "http://3.38.10.189:8000")! }
    var method: Moya.Method { .get }
    var sampleData: Data { Data() }
    var task: Task { .requestPlain }
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
