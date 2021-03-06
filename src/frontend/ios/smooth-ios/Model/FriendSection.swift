//
//  FriendSection.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/19.
//

import Foundation
import RxDataSources

enum FriendCellType {
    case empty
    case normal(Friend)
}

struct FriendSection {
    var header: String
    var items: [Item]
}

extension FriendSection: SectionModelType {
    typealias Item = FriendCellType
    
    init(original: FriendSection, items: [Item] = []) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return header
    }
}

typealias friendDataSource = RxTableViewSectionedReloadDataSource<FriendSection>

