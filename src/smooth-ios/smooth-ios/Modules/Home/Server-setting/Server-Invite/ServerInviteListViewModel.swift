//
//  ServerInviteListViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import RxSwift
import RxCocoa

class ServerInviteListViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let serverRepository: ServerRepositoryProtocol
    let server: Server
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
    }
    
    struct Output {
        let invitations = PublishRelay<[Invitation]>()
        let pastedBoard = PublishRelay<Invitation>()
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
        self.input.viewDidLoad
            .bind(onNext: self.fetch)
            .disposed(by: disposeBag)
        
        self.output.pastedBoard
            .bind(onNext: { invite in
                UIPasteboard.general.string = "https://yoloyolo.org/invite/c/\(invite.inviteCode)"
                self.showToastMessage.accept("클립보드 복사완료")
            })
            .disposed(by: disposeBag)
        
    }
    
    private func fetch() {
        serverRepository.getInvitByServer(server.id) {
            response, error in
            guard let response = response else {
                return
            }

            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
            self.output.invitations.accept(response)
        }
    }
}
