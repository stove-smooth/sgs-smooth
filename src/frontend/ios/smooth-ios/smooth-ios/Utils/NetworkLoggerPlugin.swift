//
//  NetworkLoggerPlugin.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import Foundation
import Moya

struct NetworkLoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
            guard let httpRequest = request.request else {
                print("[HTTP Request] invalid request")
                return
            }

            let url = httpRequest.description
            let method = httpRequest.httpMethod ?? "unknown method"

            /// HTTP Request Summary
            var httpLog = """
                    [HTTP Request]
                    URL: \(url)
                    TARGET: \(target)
                    METHOD: \(method)\n
                    """

            /// HTTP Request Header
            httpLog.append("HEADER: [\n")
            httpRequest.allHTTPHeaderFields?.forEach {
                httpLog.append("\t\($0): \($1)\n")
            }
            httpLog.append("]\n")

            /// HTTP Request Body
            if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: String.Encoding.utf8) {
                httpLog.append("BODY: \n\(bodyString)\n")
            }
            httpLog.append("[HTTP Request End]")

            print(httpLog)
        }

        func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
            switch result {
            case let .success(response):
                onSuceed(response, target: target, isFromError: false)
            case let .failure(error):
                onFail(error, target: target)
            }
        }

        func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
            let request = response.request
            let url = request?.url?.absoluteString ?? "nil"
            let statusCode = response.statusCode

            /// HTTP Response Summary
            var httpLog = """
                    [HTTP Response]
                    TARGET: \(target)
                    URL: \(url)
                    STATUS CODE: \(statusCode)\n
                    """

            /// HTTP Response Header
            httpLog.append("HEADER: [\n")
            response.response?.allHeaderFields.forEach {
                httpLog.append("\t\($0): \($1)\n")
            }
            httpLog.append("]\n")

            /// HTTP Response Data
            httpLog.append("RESPONSE DATA: \n")
            if let responseString = String(bytes: response.data, encoding: String.Encoding.utf8) {
                httpLog.append("\(responseString)\n")
            }
            httpLog.append("[HTTP Response End]")

            print(httpLog)
        }

        func onFail(_ error: MoyaError, target: TargetType) {
            if let response = error.response {
                onSuceed(response, target: target, isFromError: true)
                return
            }

            /// HTTP Error Summary
            var httpLog = """
                    [HTTP Error]
                    TARGET: \(target)
                    ERRORCODE: \(error.errorCode)\n
                    """
            httpLog.append("MESSAGE: \(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
            httpLog.append("[HTTP Error End]")

            print(httpLog)
        }
}

protocol Networkable {
    associatedtype Target: TargetType
    func makeProvider() -> MoyaProvider<Target>
}

extension Networkable {
    func makeProvider() -> MoyaProvider<Target> {
        
        var tokenClosure: String {
            guard let token = UserDefaultsUtil.getUserToken() else {return ""}
            return token
        }
        
        /// access token 세팅
        let authPlugin = AccessTokenPlugin {_ in
            return tokenClosure
        }
        /// 로그 세팅
        let loggerPlugin = NetworkLoggerPlugin()

      /// plugin객체를 주입하여 provider 객체 생성
        return MoyaProvider<Target>(plugins: [authPlugin, loggerPlugin])
    }
}



// back-end 팀과 정의한 에러 내용
enum ServiceError: Error {
    case moyaError(MoyaError)
    case invalidResponse(responseCode: Int, message: String)
    case tokenExpired
    case refreshTokenExpired
    case duplicateLoggedIn(message: String)
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .moyaError(let moyaError):
            return moyaError.localizedDescription
        case let .invalidResponse(_, message):
            return message
        case .tokenExpired:
            return "AccessToken Expired"
        case .refreshTokenExpired:
            return "RefreshToken Expired"
        case let .duplicateLoggedIn(message):
            return message
        }
    }
}
