//
//  EditCategoryViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit
import RxSwift
import RxCocoa

class EditCategoryViewController: BaseViewController {
    weak var coordinator: ServerSettingCoordinator?
    
    private let editView = EditCategoryView()
    private let viewModel: EditCategoryViewModel
    
    let categoryId: Int
    let categoryName: String
    
    init(categoryId: Int, categoryName: String) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.viewModel = EditCategoryViewModel(
            categoryId: categoryId, categoryName: categoryName, categoryRepository: CategoryRepository())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(categoryId: Int, categoryName: String) -> EditCategoryViewController {
        return EditCategoryViewController(categoryId: categoryId, categoryName: categoryName).then {
            $0.modalPresentationStyle = .fullScreen
        }
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
//        self.coordinator?.goToMenu()
    }
    
    override func loadView() {
        self.editView.bind(name: categoryName)
        super.view = self.editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.coordinator?.modalNav.isNavigationBarHidden = false
    }
    
    override func bindViewModel() {
        self.editView.closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        self.editView.categoryNameInput.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.categoryNameInput)
            .disposed(by: disposeBag)
        
        self.viewModel.output.showSaveButton
            .asDriver()
            .drive(onNext: { value in
                self.editView.saveButton.isHidden = !value
            })
            .disposed(by: disposeBag)
        
        self.editView.saveButton.rx.tap
            .bind(to: self.viewModel.input.tapSaveButton)
            .disposed(by: disposeBag)
        
        self.editView.deleteButton.rx.tap
            .bind(onNext: self.showDeleteCategory)
            .disposed(by: disposeBag)
        
//        self.viewModel.output.deleteCategory
//            .asDriver(onErrorJustReturn: ())
//            .drive(onNext: {
//                self.dismiss()
//            }).disposed(by: disposeBag)
        
        // MARK: toast message
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func showDeleteCategory() {
        AlertUtils.showWithCancel(
            controller: self,
            title: "채널 삭제",
            message: "정말 \(self.categoryName) 채널을 삭제할까요? 삭제하면 되돌릴 수 없어요."
        ) {
            self.viewModel.input.tapDeleteCategory.onNext(())
        }
    }
}
