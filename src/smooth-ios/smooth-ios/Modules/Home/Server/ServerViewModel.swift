//
//  ServerViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/09.
//

import Foundation
import RxSwift
import RxCocoa

struct Room {
    let url: String
    let id = UUID()
}

class ServerViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
//    let serverRepository: ServerRepository
    
    // 서버에서 오는 값 바인딩해야함
    let data = ["Logo", "Logo+Title", "AppIcon", "Logo", "Logo+Title"]
    
    struct Input {
        
    }
    
    struct Output {
        let data = PublishRelay<Room>()
        let showLoading = PublishRelay<Bool>()
    }
    
//    init(serverRepository: ServerRepository) {
//        self.serverRepository = serverRepository
//        super.init()
//    }
    
    func fetchServer() {
        self.output.showLoading.accept(true)
        
    }
    override func bind() {
        
    }
}
