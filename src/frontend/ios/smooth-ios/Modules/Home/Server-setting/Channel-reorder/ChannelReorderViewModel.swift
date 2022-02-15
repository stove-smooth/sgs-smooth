//
//  ChannelReorderViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/04.
//

import RxSwift
import RxCocoa

class ChannelReorderViewModel: BaseViewModel {
    let input = Input()
    let output = Output()

    let categories: [Category]
    let channelService: ChannelServiceProtocol
    
    struct Input {
        let inputMoveIndex = PublishSubject<[Int]>()
    }
    
    struct Output {
    }
    
    init(
        categories: [Category],
        channelService: ChannelServiceProtocol
    ) {
        self.categories = categories
        self.channelService = channelService
        super.init()
    }
    
    override func bind() {
        self.input.inputMoveIndex
            .bind(onNext: { indexs in
                let originId = indexs[0]
                let nextId = indexs[1]
                let categoryId = indexs[2]
                
                self.updateLocation(originId: originId, nextId: nextId, categoryId: categoryId)
            }).disposed(by: disposeBag)
    }
    
    private func updateLocation(originId: Int, nextId: Int, categoryId: Int) {
        self.showLoading.accept(true)
        channelService.updateLocation(originId: originId, nextId: nextId, categoryId: categoryId) {
            response, error in
            guard let response = response else {
                return
            }

            if (!response.isSuccess) {
                self.showErrorMessage.accept(response.message)
            } else {
                self.showToastMessage.accept(response.message)
            }
        }
        self.showLoading.accept(false)
    }
}
