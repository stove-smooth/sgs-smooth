//
//  MenuViewModel.swift
//  smooth-ios
//
//  Created by κΉνλ on 2022/01/08.
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
        let tapServer = PublishSubject<(IndexPath, ServerCellType)>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        
        // MARK: Binder
        //        var servers = PublishRelay<[Server]>()
        var community = PublishRelay<Community>()
        let members = PublishRelay<[Member]>()
        
        let communityInfo = PublishRelay<CommunityInfo>()
        let rooms = PublishRelay<[Room]?>()
        
        let selectedServer = PublishRelay<IndexPath>()
        let selectedChannel = PublishRelay<IndexPath?>()
        let selectedRoom = PublishRelay<RoomInfo?>()
        
        let defaultChannelIndex = PublishRelay<IndexPath>()
        let goToAddServer = PublishRelay<Void>()
    }
    
    struct Model {
        var servers: [[Server]] = []
        var directs: [Server] = []
        
        var selectedServerIndex: IndexPath = IndexPath(row: 0, section: 0)
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
            .bind { serverInfo in
                self.output.selectedChannel.accept(nil)
                
                switch serverInfo.1 {
                case .home: // MARK: λ€μ΄λ νΈ λ©μμ§ ν + λ€μ΄λ νΈ λ©μμ§ ν¨
                    self.fetchDirect()
                    self.model.selectedServerIndex = IndexPath(row: 0, section: 0)
                    self.output.selectedServer.accept(self.model.selectedServerIndex)
                    
                case .direct(let server): // MARK: μλ² λ¦¬μ€νΈ (λ―Έμμ  λ€λ  λ©μμ§)
                    self.model.selectedServerIndex = serverInfo.0
                    self.output.selectedServer.accept(self.model.selectedServerIndex)
                    self.fetchDirectById(roomId: server.id)
                    
                case .normal(let server): // MARK: μλ² λ¦¬μ€νΈ (μλ²)
                    self.model.selectedServerIndex = serverInfo.0
                    self.output.selectedServer.accept(self.model.selectedServerIndex)
                    
                    self.fetchChannel(server: server)
//                    self.fetchMemebr(server: server)
                    
                case .add: // MARK: μλ² μΆκ° λ²νΌ
                    self.model.selectedServerIndex = IndexPath(row: 0, section: 2)
                    self.output.selectedServer.accept(serverInfo.0)
                    self.output.goToAddServer.accept(())
                }
            }.disposed(by: disposeBag)
    }
    private func fetchCommunity() {
        // μ¬μ©μκ° μν μ»€λ?€λν°(λ€μ΄λ νΈ, μλ²) μ λ³΄ κ°μ Έμ€κΈ°
        self.showLoading.accept(true)
        self.serverService.fetchCommunity { community, _ in
            
            guard let community = community else {
                return
            }
            self.model.servers = [community.rooms] + [community.communities]
            
            if (!community.communities.isEmpty) {
                self.fetchChannel(server: self.model.servers[1][0])
                self.fetchMemebr(server: self.model.servers[1][0])
            }
            self.output.community.accept(community)
            self.input.tapServer.onNext((IndexPath(row: 0, section: 0), .home)) // μλ² νμΌλ‘ μ΄κΈ°ν
            
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
        self.output.rooms.accept(nil)
        
        self.serverService.getDirectRoom() { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
                self.output.rooms.accept([])
            } else {
                guard let response = response else {
                    return
                }
                
                self.model.rooms = response
                self.output.rooms.accept(self.model.rooms)
            }
            
        }
    }
    
    private func fetchDirectById(roomId: Int) {
        self.output.rooms.accept(nil)
        self.serverService.getDirectRoomById(roomId) { response, error in
            
            guard let response = response else {
                return
            }
            
            self.output.selectedRoom.accept(response)
        }
    }
}
