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
    let communityInfo: CommunityInfo
    
    struct Input {
        let tapLeaveServer = PublishSubject<Void>()
    }
    
    struct Output {
        let leaveServer = PublishRelay<Void>()
    }
    
    init(
        communityInfo: CommunityInfo,
        serverRepository: ServerRepository
    ) {
        self.communityInfo = communityInfo
        self.serverRepository = serverRepository
        super.init()
    }
    
    override func bind() {
        self.input.tapLeaveServer
            .bind(onNext: {
                self.leaveServer(serverId: self.communityInfo.id)
            })
            .disposed(by: disposeBag)
    }
    
    private func leaveServer(serverId: Int) {
        serverRepository.leaveServer(serverId) { response, error in 
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.output.leaveServer.accept(())
            }
        }
    }
}
