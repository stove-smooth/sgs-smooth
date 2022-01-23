//
//  VerifyCodeViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/05.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyCodeViewController: BaseViewController {
    private let verifyCodeView = VerifyCodeView()
    
    private let viewModel = VerifyCodeViewModel(
        userRepository: UserRepository()
    )
    
    
    weak var coordinator: MainCoordinator?
    
    static func instance() -> VerifyCodeViewController {
        return VerifyCodeViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.verifyCodeView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO : 네비게이션 바 숨기가
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.verifyCodeView.nextButton.rx.tap
            .bind(to: self.viewModel.input.tapNextButton)
            .disposed(by: disposeBag)
        
        self.verifyCodeView.verifyCodeField.rx.text
            .orEmpty
            .bind(to: self.viewModel.input.verifyCodeField)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToSignUpInfo
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToSignUpInfo)
            .disposed(by: disposeBag)
        
    }
    
    private func goToSignUpInfo() {
        self.coordinator?.goToSignUpInfo()
    }
    
}
