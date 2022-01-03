//
//  SmoothAPIRequestParameters.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/30.
//

import Foundation

enum SmoothBackend {
    enum Responses {
      
    }
}

extension SmoothBackend.Responses {
    enum Error {
        static let messageKey = "message"
        static let defaultServerError = "Unknown server error"
    }
    
    struct ErrorMessage: Codable {
        let messages: [ErrorMessage]
    }
    
    struct ErrorMessgae: Codable {
        let message: String 
    }
}

extension SmoothBackend {
    enum Parameters {
        struct SignInUser: Codable {
            let email: String
            let password: String
        }
    }
}
