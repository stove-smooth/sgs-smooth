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
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        
        let servers = PublishRelay<[Server]>()
        let communityInfo = PublishRelay<CommunityInfo>()
        let members = PublishRelay<[Member]>()
        let directs = PublishRelay<[String]>()
        
        let defaultChannelIndex = PublishRelay<IndexPath>()
        
        let goToAddServer = PublishRelay<Void>()
    }
    
    struct Model {
        var servers: [Server]?
        var selectedServerIndex: Int?
        
        var communityInfo: CommunityInfo?
        var directs: [String]?
        
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
            .bind(onNext: self.fetchServer)
            .disposed(by: disposeBag)
        
        self.input.tapServer
            .bind(onNext: { indexPath in
                switch indexPath.section {
                case 0: // 다이렉트 메시지 홈 + 다이렉트 메시지 함
                    print("홈")
                    self.model.selectedServerIndex = nil
                    self.fetchDirect()
                case 1: // 서버 리스트
                    let server = self.model.servers![indexPath.row]
                    self.model.selectedServerIndex = indexPath.row
                    self.fetchChannel(server: server)
                    self.fetchMemebr(server: server)
                case 2: // 서버 추가 버튼
                    self.model.selectedServerIndex = nil
                    self.output.goToAddServer.accept(())
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchServer() {
        self.showLoading.accept(true)
        self.serverService.fetchServer { servers, _ in
            
            guard let servers = servers else {
                return
            }
            
            self.model.servers = servers
            
            if (self.model.selectedServerIndex != nil) {
                self.fetchChannel(server: servers[0])
                self.fetchMemebr(server: servers[0])
            }
            
            self.output.servers.accept(servers)
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
