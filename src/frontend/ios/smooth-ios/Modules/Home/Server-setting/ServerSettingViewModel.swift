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
    
    let serverService: ServerServiceProtocol
    let server: Server
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(
        server: Server,
        serverService: ServerServiceProtocol
    ) {
        self.server = server
        self.serverService = serverService
        super.init()
    }
    
    override func bind() {
        
    }
}
