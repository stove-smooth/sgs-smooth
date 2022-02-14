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
    
    let serverService: ServerServiceProtocol
    let userDefaults: UserDefaultsUtil
    
    struct Input {
        let fetch = PublishSubject<Void>()
        let tapServer = PublishSubject<ServerCellType>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        
        // MARK: Binder
        //        var servers = PublishRelay<[Server]>()
        var community = PublishRelay<Community>()
        let members = PublishRelay<[Member]>()
        
        let communityInfo = PublishRelay<CommunityInfo>()
        let rooms = PublishRelay<[Room]>()
        
        let selectedServer = PublishRelay<Int?>()
        let selectedChannel = PublishRelay<IndexPath?>()
        let defaultChannelIndex = PublishRelay<IndexPath>()
        let goToAddServer = PublishRelay<Void>()
    }
    
    struct Model {
        var servers: [Server] = []
        var directs: [Server] = []
        
        var selectedServerIndex: Int?
        var communityInfo: CommunityInfo?
        var rooms: [Room] = []
        
        var members: [Member]?
        var user: Member?
    }
    
    init(
        serverService: ServerServiceProtocol,
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
            .bind(onNext: { cellType in
                self.output.selectedChannel.accept(nil)
                
                switch cellType {
                case .home: // MARK: 다이렉트 메시지 홈 + 다이렉트 메시지 함
                    self.fetchDirect()
                    self.model.selectedServerIndex = nil
                    self.output.selectedServer.accept(nil)
                    
                case .direct(let server): // MARK: 서버 리스트 (미수신 다렉 메시지)
                    self.model.selectedServerIndex = self.model.servers.firstIndex(of: server)
                    self.output.selectedServer.accept(self.model.selectedServerIndex)
                    print("다렉으로 이동")
                    
                case .normal(let server): // MARK: 서버 리스트 (서버)
                    self.model.selectedServerIndex = self.model.servers.firstIndex(of: server)
                    self.output.selectedServer.accept(self.model.selectedServerIndex)
                    
                    self.fetchChannel(server: server)
                    self.fetchMemebr(server: server)
                    
                case .add: // MARK: 서버 추가 버튼
                    self.model.selectedServerIndex = nil
                    self.output.selectedServer.accept(nil)
                    self.output.goToAddServer.accept(())
                }
            }).disposed(by: disposeBag)
    }
    
    
    private func fetchCommunity() {
        // 사용자가 속한 커뮤니티(다이렉트, 서버) 정보 가져오기
        self.showLoading.accept(true)
        self.serverService.fetchCommunity { community, _ in
            
            guard let community = community else {
                return
            }
            self.model.servers = community.rooms + community.communities
            
            
            if (self.model.selectedServerIndex != nil) {
                self.fetchChannel(server: self.model.servers[0])
                self.fetchMemebr(server: self.model.servers[0])
            }
            
            self.output.community.accept(community)
            self.input.tapServer.onNext(.home) // 서버 홈으로 초기화
            
            self.output.showLoading.accept(false)
        }
    }
    
    
    
    private func fetchChannel(server: Server) {
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
            self.model.user = me
            
            self.output.members.accept(response)
        }
    }
    
    private func fetchDirect() {
        self.serverService.getDirectRoom() { response, error in
            
            guard let response = response else {
                return
            }
            
            self.model.rooms = response
            self.output.rooms.accept(self.model.rooms)
        }
    }
}
