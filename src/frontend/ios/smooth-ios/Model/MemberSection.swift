//
//  MemberSection.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/17.
//

import Foundation
import RxDataSources

enum MemberCellType {
    case online(Member)
    case offline(Member)
}

struct MemberSection {
    var header: String
    var items: [Item]
}

extension MemberSection: SectionModelType {
    typealias Item = MemberCellType
    
    init(original: MemberSection, items: [MemberCellType]) {
        self = original
        self.items = items
    }
    
    var identity: String {
        return header
    }
}

typealias memberDataSource = RxTableViewSectionedReloadDataSource<MemberSection>
