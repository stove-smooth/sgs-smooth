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

    let serverRepository: ServerRepository
    let server: Server
    let member: Member
    
    struct Input {
        let tapLeaveServer = PublishSubject<Void>()
    }
    
    struct Output {
        let leaveServer = PublishRelay<Void>()
    }
    
    init(
        server: Server,
        member: Member,
        serverRepository: ServerRepository
    ) {
        self.server = server
        self.member = member
        self.serverRepository = serverRepository
        super.init()
    }
    
    override func bind() {
        self.input.tapLeaveServer
            .bind(onNext: {
                self.leaveServer(serverId: self.server.id, memberId: self.member.id)
            })
            .disposed(by: disposeBag)
    }
    
    private func leaveServer(serverId: Int, memberId: Int) {
        serverRepository.leaveServer(serverId: serverId, memberId: memberId) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.output.leaveServer.accept(())
            }
        }
    }
}
