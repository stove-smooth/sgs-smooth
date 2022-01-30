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
    let userDefaults: UserDefaultsUtil
    
    struct Input {
        let fetch = PublishSubject<Void>()
        let tapServer = PublishSubject<IndexPath>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        
        let servers = PublishRelay<[Server]>()
        let communityInfo = PublishRelay<CommunityInfo>()
        let members = PublishRelay<[Member]>()
        
        let goToAddServer = PublishRelay<Void>()
    }
    
    struct Model {
        var servers: [Server]?
        var selectedServerIndex: Int?
        
        var communityInfo: CommunityInfo?
        
        var members: [Member]?
        var me: Member?
    }
    
    init(
        serverRepository: ServerRepository,
        userDefaults: UserDefaultsUtil
    ) {
        self.serverRepository = serverRepository
        self.userDefaults = userDefaults
        
        super.init()
    }
    
    private func fetchServer() {
        self.showLoading.accept(true)
        self.serverRepository.fetchServer { servers, _ in
            
            guard let servers = servers else {
                return
            }
            
            self.model.servers = servers
            
            if (servers.count > 0) {
                self.fetchChannel(server: servers[0])
                self.fetchMemebr(server: servers[0])
            }
            
            self.output.servers.accept(servers)
            self.output.showLoading.accept(false)
        }
    }
    
    private func fetchChannel(server: Server){
        self.serverRepository.getServerById(server.id) { response, error in
            
            guard let response = response else {
                return
            }
            
            self.model.communityInfo = response
            self.output.communityInfo.accept(response)
        }
    }
    
    private func fetchMemebr(server: Server) {
        self.serverRepository.getMemberFromServer(server.id) { response, error in
            
            guard let response = response else {
                return
            }
            let user = self.userDefaults.getUserInfo()
            
            let me = response.filter {$0.code == user?.code}[0]
            
            self.model.members = response
            self.model.me = me
            
            self.output.members.accept(response)
        }
    }
    
    override func bind() {
        self.input.fetch
            .bind(onNext: self.fetchServer)
            .disposed(by: disposeBag)
        
        self.input.tapServer
            .bind(onNext: { indexPath in
                switch indexPath.section {
                case 0:
                    // TODO: 다이렉트 메시지 홈 + 다이렉트 메시지 함
                    print("홈")
                case 1:
                    let server = self.model.servers![indexPath.row]
                    self.model.selectedServerIndex = indexPath.row
                    self.fetchChannel(server: server)
                    self.fetchMemebr(server: server)
                case 2:
                    self.output.goToAddServer.accept(())
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
}
