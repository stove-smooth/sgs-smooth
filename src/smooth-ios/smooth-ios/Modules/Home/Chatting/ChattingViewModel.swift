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
    
    let chattingRepository: ChattingRepository
    
    struct Input {
        let fetch = PublishSubject<Void>()
    }
    
    struct Output {
        let channel = PublishRelay<Channel>()
        let messages = PublishRelay<[Message]>()
    }
    
    struct Model {
        var messgae: [Message] = []
    }
    
    init(
        chattingRepository: ChattingRepository
    ) {
        self.chattingRepository = chattingRepository
        super.init()
    }
    
    override func bind() {
        self.input.fetch
            .subscribe(onNext: {
                self.fetchMessgae(chattingId: 1)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchMessgae(chattingId: Int) {
        chattingRepository.fetchMessgae(chattingId) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                guard let response = response else {
                    return
                }

                self.model.messgae = response
                self.output.messages.accept(response)
            }
        }
    }
}
