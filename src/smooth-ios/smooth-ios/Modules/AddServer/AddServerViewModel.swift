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
    
    let serverRepository: ServerRepositoryProtocol
    
    struct Input {
        
    }
    
    struct Output {
        let dismiss = PublishRelay<Void>()
    }
    
    init(
        serverRepository: ServerRepositoryProtocol
    ) {
        self.serverRepository = serverRepository
        super.init()
    }
    
    override func bind() {
     
    }
}
