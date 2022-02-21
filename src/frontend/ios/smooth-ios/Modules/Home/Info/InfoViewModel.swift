//
//  InfoViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/17.
//

import RxSwift
import RxCocoa

class InfoViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    let models: Model
    
    let serverService: ServerServiceProtocol
    
    struct Input {
        let viewDidLoad = PublishSubject<Void>()
    }
    
    struct Output {
        let members = PublishRelay<[Member]>()
    }
    
    struct Model {
        let isGroup: Bool
        let id: Int
    }
    
    init(isGroup: Bool,
         id: Int,
         serverService: ServerServiceProtocol) {
        self.models = Model(isGroup: isGroup, id: id)
        self.serverService = serverService
        super.init()
    }
    
    override func bind() {
        self.input.viewDidLoad
            .bind(onNext: {
                if (self.models.isGroup) { // 커뮤니티인 경우
                    self.fetchMemebrByCommunity(communityId: self.models.id)
                } else { // 다이렉트인 경우
                    self.fetchMemebrByDirect(directId: self.models.id)
                }
            }).disposed(by: disposeBag)
    }
    
    private func fetchMemebrByCommunity(communityId: Int) {
        self.serverService.getMemberFromServer(communityId) { response, error in
            
            guard let response = response else {
                return
            }
            
            self.output.members.accept(response)
        }
    }
    
    private func fetchMemebrByDirect(directId: Int) {
        self.serverService.getDirectRoomById(directId) { response, error in
            
            guard let response = response else {
                return
            }
            
            let members = response.members.map {
                Member(id: $0.id,
                       profileImage: $0.image,
                       communityName: "direct_\(self.models.id)",
                       nickname: $0.nickname,
                       code: $0.code,
                       role: $0.owner ? .owner : .none,
                       status: PresenceStatus(rawValue: $0.state) ?? .unknown)
            }
            
            self.output.members.accept(members)
        }
    }
}
