//
//  ServerSection.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import Foundation
import RxDataSources

enum ServerCellType {
    case home
    case normal(Server)
    case add
}

struct ServerSection {
    var header: String
    var items: [Item]
}

extension ServerSection: SectionModelType {
    typealias Item = ServerCellType
    
    init(original: ServerSection, items: [ServerCellType]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return header
    }
}

typealias serverDataSource = RxTableViewSectionedReloadDataSource<ServerSection>
