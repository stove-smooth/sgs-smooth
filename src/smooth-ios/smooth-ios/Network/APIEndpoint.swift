//
//  SmoothAPI.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import Foundation
import Moya

protocol APIEndpoint {
  var baseURL: URL { get }
  var parametersEncoder: JSONEncoder { get }
  var responseDecoder: JSONDecoder { get }
  var headers: [String: String]? { get }
  var sampleData: Data { get }
}
