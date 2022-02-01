//
//  EditCategoryViewModel.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import RxSwift
import RxCocoa

class EditCategoryViewModel: BaseViewModel {
    let input = Input()
    let output = Output()
    
    let categoryRepository: CategoryRepositoryProtocol
    let categoryId: Int
    let categoryName: String
    
    struct Input {
        let categoryNameInput = BehaviorRelay<String>(value: "")
        let tapDeleteCategory = PublishSubject<Void>()
        let tapSaveButton = PublishSubject<Void>()
    }
    
    struct Output {
        let showSaveButton = BehaviorRelay<Bool>(value: true)
        let dismiss = PublishRelay<Void>()
    }
    
    init(
        categoryId: Int,
        categoryName: String,
        categoryRepository: CategoryRepositoryProtocol
    ) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.categoryRepository = categoryRepository
        super.init()
    }
    
    override func bind() {
        self.input.tapDeleteCategory
            .bind(onNext: {
                self.deleteCategory()
                self.output.dismiss.accept(())
            }).disposed(by: disposeBag)
        
        self.input.categoryNameInput
            .subscribe(onNext: { value in
                self.showSaveButton(input: value)
            }).disposed(by: disposeBag)
        
        self.input.tapSaveButton
            .bind(onNext: {
                self.updateCategoryName()
                self.showToastMessage.accept("변경 완료")
            }).disposed(by: disposeBag)
    }
    
    private func showSaveButton(input: String) {
        let show = (input != self.categoryName)
        self.output.showSaveButton.accept(show)
    }
    
    
    private func deleteCategory() {
        self.showLoading.accept(true)
        categoryRepository.deleteCategory(categoryId: self.categoryId) {
            response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
        }
        self.showLoading.accept(false)
    }
    
    private func updateCategoryName() {
        self.showLoading.accept(true)
        categoryRepository.updateCategoryName(
            categoryId: self.categoryId,
            name: self.input.categoryNameInput.value) {
            response, error in
            if (error?.response != nil) {
                let body = try! JSONDecoder().decode(DefaultResponse.self, from: error!.response!.data)
                self.showErrorMessage.accept(body.message)
            }
        }
        self.showLoading.accept(false)
    }
}
