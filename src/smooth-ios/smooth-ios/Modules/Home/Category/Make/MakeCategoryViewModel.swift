//
//  MakeCategoryViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import RxSwift
import RxCocoa

class MakeCategoryViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let categoryService: CategoryServiceProtocol
    let server: Server
    
    struct Input {
        let categoryNameInput = BehaviorRelay<String>(value: "")
        let isPublic = BehaviorRelay<Bool>(value: false)
        
        let tapMakeButton = PublishSubject<Void>()
    }
    
    struct Output {
        let goToMain = PublishRelay<Void>()
    }
    
    init(
        server: Server,
        categoryService: CategoryServiceProtocol
    ) {
        self.server = server
        self.categoryService = categoryService
        super.init()
    }
    
    override func bind() {
        self.input.tapMakeButton
            .bind(onNext: {
                print("tap Make Button")
                
                if (self.input.categoryNameInput.value.count>0) {
                    self.createCategory(request: CategoryReqeust(
                        communityId: self.server.id,
                        name: self.input.categoryNameInput.value,
                        public: self.input.isPublic.value,
                        menbers: nil
                    ))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func createCategory(request: CategoryReqeust) {
        categoryService.createCategory(request: request) { response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            } else {
                self.showToastMessage.accept("카테고리 생성완료")
                self.output.goToMain.accept(())
            }
        }
    }
}
