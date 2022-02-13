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
    
    let serverService: ServerService
    let userDefaults: UserDefaultsUtil
    
    struct Input {
        let fetch = PublishSubject<Void>()
        let tapServer = PublishSubject<IndexPath>()
        
        let menuPipline = PublishSubject<Void>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        
        // MARK: Binder
        let servers = PublishRelay<[Server]>()
        let selectedServer = PublishRelay<Int?>()
        let communityInfo = PublishRelay<CommunityInfo>()
        let selectedChannel = PublishRelay<IndexPath?>()
        let directs = PublishRelay<[String]>()
        
        let members = PublishRelay<[Member]>()
        
        let defaultChannelIndex = PublishRelay<IndexPath>()
        
        let goToAddServer = PublishRelay<Void>()
    }
    
    struct Model {
        var servers: [Server] = []
        var directs: [Server] = []
        
        var selectedServerIndex: Int?
        var communityInfo: CommunityInfo?
        
        var members: [Member]?
        var me: Member?
    }
    
    init(
        serverService: ServerService,
        userDefaults: UserDefaultsUtil
    ) {
        self.serverService = serverService
        self.userDefaults = userDefaults
        
        super.init()
    }
    
    override func bind() {
        self.input.fetch
            .bind(onNext: self.fetchCommunity)
            .disposed(by: disposeBag)
        
        self.input.tapServer
            .bind(onNext: { indexPath in
                self.output.selectedChannel.accept(nil)
                
                switch indexPath.section {
                case 0: // 다이렉트 메시지 홈 + 다이렉트 메시지 함
                    print("홈")
                    self.model.selectedServerIndex = nil
                    self.output.selectedServer.accept(nil)
                    self.fetchDirect()
                case 1: // 서버 리스트
                    let server = self.model.servers[indexPath.row]
                    self.model.selectedServerIndex = self.model.servers.firstIndex(of: server)
                    
                    self.output.selectedServer.accept(self.model.selectedServerIndex)
                    self.fetchChannel(server: server)
                    
                    self.fetchMemebr(server: server)
                case 2: // 서버 추가 버튼
                    self.model.selectedServerIndex = nil
                    self.output.selectedServer.accept(nil)
                    
                    self.output.goToAddServer.accept(())
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchCommunity() {
        self.showLoading.accept(true)
        self.serverService.fetchCommunity { community, _ in
            
            guard let community = community else {
                return
            }
            
            self.model.directs = community.rooms
            self.model.servers = community.communities
            

            if (self.model.selectedServerIndex != nil) {
                self.fetchChannel(server: self.model.servers[0])
                self.fetchMemebr(server: self.model.servers[0])
            }
            
            self.output.servers.accept(self.model.servers)
            self.output.selectedServer.accept(self.model.selectedServerIndex)
            self.output.showLoading.accept(false)
        }
    }
    
    private func fetchChannel(server: Server){
        self.serverService.getServerById(server.id) { response, error in
            
            guard let response = response else {
                return
            }
            
            self.model.communityInfo = response
            self.output.communityInfo.accept(response)
        }
    }
    
    private func fetchMemebr(server: Server) {
        self.serverService.getMemberFromServer(server.id) { response, error in
            
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
    
    private func fetchDirect() {
        // TODO: 1:1 챗방 리스트 불러오기
        self.output.directs.accept([])
    }
}
