//
//  InviteServerViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/27.
//

import RxSwift
import RxCocoa

class InviteServerViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    var serverId: Int
    let serverService: ServerServiceProtocol
    let friendService: FriendServiceProtocol
    
    var frienSections: [FriendSection] = []
    var inviteCode: String?
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
    }
    
    struct Output {
        let showLoading = PublishRelay<Bool>()
        let showEmpty = PublishRelay<Bool>()
        let pastedBoard = PublishRelay<Void>()
        
        let inviteCode = PublishRelay<String>()
        let frienSections = PublishRelay<[FriendSection]>()
        
        let invite = PublishRelay<Friend>()
        let goToMain = PublishRelay<Void>()
    }
    
    init(serverId: Int,
         serverService: ServerServiceProtocol,
         friendService: FriendServiceProtocol
    ) {
        self.serverId = serverId
        self.serverService = serverService
        self.friendService = friendService
    }
    
    override func bind() {
        self.input.viewDidLoad
            .bind(onNext: self.fetch)
            .disposed(by: disposeBag)
        
        self.output.invite
            .bind(onNext: { friend in
#warning("server - invite friend")
                print("invite chatting 연결하기 \(friend)")
            }).disposed(by: disposeBag)
        
        self.output.pastedBoard
            .bind(onNext: {
                self.showToastMessage.accept("클립보드 복사완료")
            })
            .disposed(by: disposeBag)
    }
    
    private func fetch() {
        self.output.showLoading.accept(false)
        
        self.fetchInviteCode()
        self.fetchFriend()
        
        self.output.showLoading.accept(false)
    }
    
    private func fetchInviteCode() {
        serverService.createInvitation(serverId) {
            response, error in
            
            guard let response = response else {
                return
            }
            
            self.inviteCode = response
            self.output.inviteCode.accept(response)
        }
    }
    
    private func fetchFriend() {
        self.friendService.fetchFriend { friends, _ in
            guard let friends = friends else {
                return
            }
            
            self.output.frienSections.accept(friends)
            self.frienSections = friends
            
            if friends.count == 0 {
                self.output.showEmpty.accept(true)
            } else {
                self.output.showEmpty.accept(false)
            }
        }
    }
    
}
