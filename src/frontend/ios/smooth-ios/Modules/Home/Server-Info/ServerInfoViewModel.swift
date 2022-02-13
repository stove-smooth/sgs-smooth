//
//  ServerInfoViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/28.
//

import RxSwift
import RxCocoa

class ServerInfoViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    let model: Model
    
    let serverService: ServerService
    
    
    struct Input {
        let tapLeaveServer = PublishSubject<Void>()
    }
    
    struct Output {
        let leaveServer = PublishRelay<Void>()
    }
    
    struct Model {
        var server: Server
        var member: Member
    }
    
    init(
        server: Server,
        member: Member,
        serverService: ServerService
    ) {
        self.model = Model(server: server, member: member)
        self.serverService = serverService
        super.init()
    }
    
    override func bind() {
        self.input.tapLeaveServer
            .bind(onNext: {
                self.leaveServer(serverId: self.model.server.id, memberId: self.model.member.id)
            })
            .disposed(by: disposeBag)
    }
    
    private func leaveServer(serverId: Int, memberId: Int) {
        serverService.leaveServer(serverId: serverId, memberId: memberId) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.output.leaveServer.accept(())
            }
        }
    }
}
