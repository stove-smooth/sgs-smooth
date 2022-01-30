//
//  ServerSettingViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import RxSwift
import RxCocoa

class ServerSettingViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let serverRepository: ServerRepositoryProtocol
    let server: Server
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(
        server: Server,
        serverRepository: ServerRepositoryProtocol
    ) {
        self.server = server
        self.serverRepository = serverRepository
        super.init()
    }
    
    override func bind() {
        
    }
}
