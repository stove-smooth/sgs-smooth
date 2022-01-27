//
//  ChannelSection.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation
import RxDataSources

struct ChannelSection {
    var header: String
    var id: Int
    var items: [Item]
    
    init(header: String, id: Int, items: [Item]) {
        self.header = header
        self.items = items
        self.id = id
    }
    
    var identity: Int {
        return self.id
    }
}

extension ChannelSection: SectionModelType {
    
    typealias Item = Channel
    
    init(original: ChannelSection, items: [Channel]) {
        self = original
        self.items = items
    }
}

typealias channelDataSource = RxTableViewSectionedReloadDataSource<ChannelSection>
