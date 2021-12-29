//
//  Utils.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import Foundation
import Alamofire
import UIKit

struct HTTPUtils {
    static let url = "http://99.81.71.134:8000"
    
    static let defaultSession: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        
        return Session(configuration: config)
    }()
    
    static func jsonHeader() -> HTTPHeaders {
        let headers = ["Accept": "application/json"] as HTTPHeaders
        
        return headers
    }
    
    static func jsonWithTokenHeader() -> HTTPHeaders {
      let headers = [
        "Accept": "application/json",
        "Authorization": UserDefaultsUtil().getUserToken()
      ] as HTTPHeaders
      
      return headers
    }
    
    static func defaultHeader() -> HTTPHeaders {
        let headers = ["Authorization": "Bearer "+UserDefaultsUtil().getUserToken()] as HTTPHeaders
    
      return headers
    }
}

struct JsonUtils {
  
  static func toJson<T: Decodable>(of type: T.Type = T.self, object: Any) -> T? {
    if let jsonData = try? JSONSerialization.data(withJSONObject: object) {
      let decoder = JSONDecoder()
      let result = try? decoder.decode(T.self, from: jsonData)
      
      return result
    } else {
      return nil
    }
  }
}

