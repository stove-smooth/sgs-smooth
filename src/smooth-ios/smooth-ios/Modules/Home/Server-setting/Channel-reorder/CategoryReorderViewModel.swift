//
//  ChannelReorderViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import RxSwift
import RxCocoa

class CategoryReorderViewModel: BaseViewModel {
    let input = Input()
    let output = Output()

    let categories: [Category]
    let categoryService: CategoryServiceProtocol
    
    struct Input {
        let inputMoveIndex = PublishSubject<[Int]>()
    }
    
    struct Output {
    }
    
    init(
        categories: [Category],
        categoryService: CategoryServiceProtocol
    ) {
        self.categories = categories
        self.categoryService = categoryService
        super.init()
    }
    
    override func bind() {
        self.input.inputMoveIndex
            .bind(onNext: { indexs in
                let originId = indexs[0]
                let nextId = indexs[1]
                
                self.updateLocation(originId: originId, nextId: nextId)
            }).disposed(by: disposeBag)
    }
    
    private func updateLocation(originId: Int, nextId: Int) {
        self.showLoading.accept(true)
        categoryService.updateLocation(originId: originId, nextId: nextId) {
            response, error in
            guard let response = response else {
                return
            }

            if (!response.isSuccess) {
                self.showErrorMessage.accept(response.message)
            }
        }
        self.showLoading.accept(false)
    }
}
