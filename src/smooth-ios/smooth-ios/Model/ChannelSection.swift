//
//  ChannelSection.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/24.
//

import Foundation
import RxDataSources


struct Channel: Codable, Equatable, IdentifiableType {
    var id: String
    var name: String
    var identity: String {
        return self.id
    }
}

struct ChannelSection {
    var header: String
    var items: [Item]
    var identity: String
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension ChannelSection: AnimatableSectionModelType {
    typealias Item = Channel
    
    init(original: ChannelSection, items: [Channel]) {
        self = original
        self.items = items
    }
}

typealias channelDataSource = RxTableViewSectionedReloadDataSource<ChannelSection>
