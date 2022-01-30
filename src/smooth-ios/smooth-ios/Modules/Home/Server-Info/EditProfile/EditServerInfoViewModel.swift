//
//  EditProfileViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import RxSwift
import RxCocoa

class EditServerInfoViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let serverRepository: ServerRepositoryProtocol
    let server: Server
    
    struct Input {
        let tapDeleteServer = PublishSubject<Void>()
    }
    
    struct Output {
        let deleteServer = PublishRelay<Void>()
    }
    
    init(
        server: Server,
        serverRepository: ServerRepositoryProtocol
    ) {
        self.server = server
        self.serverRepository = serverRepository
        super.init()
    }
    
    override func bind() {
        self.input.tapDeleteServer
            .bind(onNext: {
                self.deleteServer(serverId: self.server.id)
            }).disposed(by: disposeBag)
    }
    
    private func deleteServer(serverId: Int) {
        serverRepository.deleteServer(serverId) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.output.deleteServer.accept(())
            }
        }
    }
}
