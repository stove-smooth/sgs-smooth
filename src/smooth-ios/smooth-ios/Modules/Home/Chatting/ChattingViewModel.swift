//
//  ChattingViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import Foundation
import RxSwift
import RxCocoa

class ChattingViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    var model = Model()
    
    let chattingService: ChattingService
    
    struct Input {
        let fetch = PublishSubject<Channel>()
        let page = BehaviorRelay<Int>(value: 0)
        let size = BehaviorRelay<Int>(value: 20)
    }
    
    struct Output {
        let channel = PublishRelay<Channel>()
        let messages = PublishRelay<[Message]>()
        
        let showEmpty = PublishRelay<Bool>()
    }
    
    struct Model {
        var messgae: [Message] = []
    }
    
    init(
        chattingService: ChattingService
    ) {
        self.chattingService = chattingService
        super.init()
    }
    
    override func bind() {
        self.input.fetch
            .subscribe(onNext: { channel in
                self.fetchMessgae(chattingId: channel.id)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMessgae(chattingId: Int) {
        
        let page = self.input.page.value
        let size = self.input.size.value
        
        chattingService.fetchMessgae(chattingId, page: page, size: size) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                guard let response = response else {
                    return
                }
                
                self.output.showEmpty.accept(response.count == 0)
                self.model.messgae = response
                self.output.messages.accept(response)
            }
        }
    }
}
