//
//  MakeServerViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import RxSwift
import RxCocoa

class MakeServerViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let serverRepository: ServerRepositoryProtocol
    
    struct Input {
        let tapPrivateButton = PublishSubject<Void>()
    }
    
    struct Output {
        
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
