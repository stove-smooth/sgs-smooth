//
//  Server.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/28.
//

import Foundation
import RxDataSources

struct Server: Codable, Equatable, IdentifiableType {
    let id: Int
    let name: String
    let icon: String?
    let count: Int?
    
    var identity: Int {
        return self.id
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.icon = nil
        self.count = nil
    }
    
    init(id: Int, name: String, icon: String?) {
        self.id = 0
        self.name = ""
        self.icon = nil
        self.count = nil
    }
}

struct ServerRequest: Codable {
    let name: String
    let `public`: Bool
    let icon: Data?
}

struct InvitationResponse: Codable {
    let url: String
}
