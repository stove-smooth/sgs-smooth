//
//  Server.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/28.
//

import Foundation

struct Server: Codable, Equatable {
    let id: Int
    let name: String
    let icon: String?
    
    var identity: Int {
        return self.id
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.icon = nil
    }
    
    init(id: Int, name: String, icon: String?) {
        self.id = 0
        self.name = ""
        self.icon = nil
    }
}
