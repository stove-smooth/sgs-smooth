//
//  AddServerViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import RxSwift
import RxCocoa

class AddServerViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let serverService: ServerServiceProtocol
    
    struct Input {
        
    }
    
    struct Output {
        let dismiss = PublishRelay<Void>()
    }
    
    init(
        serverService: ServerServiceProtocol
    ) {
        self.serverService = serverService
        super.init()
    }
    
    override func bind() {
     
    }
}
