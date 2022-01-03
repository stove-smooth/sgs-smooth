//
//  SmoothBackendAPIEndpointProtocol.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import Foundation

protocol SmoothBackendAPIEndpointProtocol: APIEndpoint {
}

extension SmoothBackendAPIEndpointProtocol {
    var baseURL: URL {
        return SmoothBackendAPI.baseURL
    }
    
    var parametersEncoder: JSONEncoder {
        return SmoothBackendAPI.parametersEncoder
    }
    
    var responseDecoder: JSONDecoder {
        return SmoothBackendAPI.responseDecoder
    }
    
    var headers: [String : String]? {
        return SmoothBackendAPI.headers
    }
    
    var sampleData: Data {
        return SmoothBackendAPI.sampleData
    }
}
