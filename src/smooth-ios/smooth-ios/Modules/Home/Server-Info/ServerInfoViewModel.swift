//
//  ServerInfoViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/28.
//

import Foundation

class ServerInfoViewModel: BaseViewModel {
    let input = Input()
    let output = Output()

    let serverRepository: ServerRepository
    
    let communityInfo: CommunityInfo
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(
        communityInfo: CommunityInfo,
        serverRepository: ServerRepository
    ) {
        self.communityInfo = communityInfo
        self.serverRepository = serverRepository
        super.init()
    }
    
    override func bind() {
        
    }
    
    
}
