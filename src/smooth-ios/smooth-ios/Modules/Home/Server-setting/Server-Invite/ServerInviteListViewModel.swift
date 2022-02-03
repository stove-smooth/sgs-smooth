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
    
    let serverService: ServerServiceProtocol
    let server: Server
    var invitations: [Invitation] = []
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
        let tapDeleteButton = PublishRelay<Invitation>()
    }
    
    struct Output {
        let invitations = PublishRelay<[Invitation]>()
        let pastedBoard = PublishRelay<Invitation>()
        let showEmpty = PublishRelay<Bool>()
    }
    
    init(
        server: Server,
        serverService: ServerServiceProtocol
    ) {
        self.server = server
        self.serverService = serverService
        super.init()
    }
    
    override func bind() {
        self.input.viewDidLoad.bind(onNext: self.fetch)
            .disposed(by: disposeBag)
        
        self.output.pastedBoard
            .bind(onNext: { invite in
                UIPasteboard.general.string = "https://yoloyolo.org/invite/c/\(invite.inviteCode)"
                self.showToastMessage.accept("클립보드 복사완료")
            })
            .disposed(by: disposeBag)
        
        self.input.tapDeleteButton
            .subscribe(onNext: { invitation in
                self.deleteInvitation(invitation: invitation)

            }).disposed(by: disposeBag)
        
    }
    
    private func fetch() {
        serverService.getInvitByServer(server.id) {
            response, error in
            guard let response = response else {
                return
            }

            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
            
            self.output.showEmpty.accept(response.count == 0)
            self.invitations = response
            
            self.output.invitations.accept(response)
        }
    }
    
    private func deleteInvitation(invitation: Invitation) {
        serverService.deleteinvitation(invitation.id) {
            response, error in
            
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
            
            let index = self.invitations.firstIndex(of: invitation)
            
            self.invitations.remove(at: index!)
            self.output.showEmpty.accept(self.invitations.count == 0)
            
            self.output.invitations.accept(self.invitations)
            
            
            self.showToastMessage.accept("초대장 취소 완료")
        }
    }
}
