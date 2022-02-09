//
//  MakeChannelViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import RxSwift
import RxCocoa

class MakeChannelViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let channelService: ChannelServiceProtocol
    let categoryId: Int
    
    struct Input {
        let channelNameInput = BehaviorRelay<String>(value: "")
        let isChat = BehaviorRelay<Bool>(value: true)
        let isPublic = BehaviorRelay<Bool>(value: false)
        let tapMakeButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToMain = PublishRelay<Void>()
    }
    
    init(
        categoryId: Int,
        channelService: ChannelServiceProtocol
    ) {
        self.categoryId = categoryId
        self.channelService = channelService
        super.init()
    }
    
    
    override func bind() {
        self.input.tapMakeButton
            .bind(onNext: {
                let name = self.input.channelNameInput.value
                let type = self.input.isChat.value ? "TEXT" : "VOICE"
                if (name.count > 1) {
                    self.createChannel(request: ChannelRequest(
                        id: self.categoryId,
                        name: name,
                        type: type,
                        public: self.input.isPublic.value
                    ))
                }
            }).disposed(by: disposeBag)
    }
    
    private func createChannel(request: ChannelRequest) {
        channelService.createChannel(request: request) {
         response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.showToastMessage.accept("채널 생성완료")
                self.output.goToMain.accept(())
            }
        }
    }
}
