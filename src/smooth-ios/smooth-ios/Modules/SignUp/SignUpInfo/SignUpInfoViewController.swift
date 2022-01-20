//
//  SignUpInfoViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import Foundation


class SignUpInfoViewController: BaseViewController {
    private let signUpInfoView = SignUpInfoView()
    private let viewModel = SignUpInfoViewModel()
    
    weak var coordinator: MainCoordinator?
    
    static func instance() -> SignUpInfoViewController {
        return SignUpInfoViewController(nibName: nil, bundle: nil)
    }
    
    
    override func loadView() {
        super.view = self.signUpInfoView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: 네비게이션 바 숨기기
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.signUpInfoView.nextButton.rx.tap
            .bind(to: self.viewModel.input.tapNextButton)
            .disposed(by: disposeBag)
        
        self.signUpInfoView.nickNameField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.nickNameField)
            .disposed(by: disposeBag)
    }
    
    private func goToMain() {
        self.coordinator?.goToMain()
    }
}
