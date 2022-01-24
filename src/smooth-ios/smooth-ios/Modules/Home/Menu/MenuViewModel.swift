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
        let tapServer = PublishSubject<Int>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        
        let servers = PublishRelay<[Server]>()
        let categories = PublishRelay<[Category]>()
    }
    
    struct Model {
        var servers: [Server]?
        var categories: [Category]?
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
            self.fetchChannel(server: servers[0])
            self.output.servers.accept(servers)
            self.output.showLoading.accept(false)
        }
    }
    
    private func fetchChannel(server: Server){
        self.showLoading.accept(true)
        self.serverRepository.getServerById(server.id) { response, error in
            
            guard let response = response else {
                return
            }

            
            self.model.categories = response.categories
            
            self.output.categories.accept(response.categories)
            self.output.showLoading.accept(false)
            
        }
    }

    override func bind() {
        self.input.fetch
            .bind(onNext: self.fetchServer)
            .disposed(by: disposeBag)
        
        self.input.tapServer
            .map { self.model.servers![$0] }
            .bind(onNext: self.fetchChannel(server:))
            .disposed(by: disposeBag)
    }
}
