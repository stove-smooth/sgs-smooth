//
//  MenuViewModel.swift
//  smooth-ios
//
//  Created by 김하나 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

class MenuViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    var model = Model()
    
    let serverRepository: ServerRepository
    
    struct Input {
        let fetch = PublishSubject<Void>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        
        let servers = PublishRelay<[Server]>()
    }
    
    struct Model {
        var servers: [Server]?
        var channels: [Channel]?
    }
    
    init(serverRepository: ServerRepository) {
        self.serverRepository = serverRepository
        super.init()
    }
    
    private func fetchServer() {
        self.showLoading.accept(true)
        self.serverRepository.fetchServer { servers, _ in
            
            guard let servers = servers else {
                return
            }
            
            self.model.servers = servers
    
            self.output.servers.accept(servers)
            self.output.showLoading.accept(false)
        }
    }

    override func bind() {
        self.input.fetch
            .bind(onNext: self.fetchServer)
            .disposed(by: disposeBag)
    }
}
