//
//  SmoothBackendAPI.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import UIKit

enum SmoothBackendAPI: CoderConfigProtocol {
    
    static let baseURL: URL = {
        #if DEVELOPMENT
        let url = URL(string: "http://3.38.10.189:8000")!
        #else
        let url = URL(string: "http://3.38.10.189:8000")!
        #endif
        return url
    }()
    
    static let parametersEncoder: JSONEncoder = {
      let coder = JSONEncoder()
      coder.keyEncodingStrategy = .convertToSnakeCase
      return coder
    }()
    
    static let responseDecoder: JSONDecoder = {
      let coder = JSONDecoder()
      coder.keyDecodingStrategy = .convertFromSnakeCase
      return coder
    }()
    
    static let headers: [String: String]? = {
      return ["Content-type": "application/json"]
    }()
    
    static let sampleData: Data = {
        return Data()
    }()
}


extension SmoothBackendAPI {
    enum Auth: SmoothBackendAPIEndpointProtocol {
        case signin(SmoothBackend.Parameters.SignInUser, responseMapping: SmoothBackend.Responses.SignInResponse.Type)
        case signOut
    }
}
