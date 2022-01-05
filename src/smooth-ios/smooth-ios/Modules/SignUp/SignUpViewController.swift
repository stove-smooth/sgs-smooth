//
//  SignUpViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import UIKit
import RxSwift
import RxCocoa
import Then


class SignUpViewController: BaseViewController {
    private let signUpView = SignUpView()
    private let viewModel = SignUpViewModel(
        userDefaults: UserDefaultsUtil()
    )
    
    weak var coordinator: MainCoordinator?
    
    static func instance() -> SignUpViewController {
        return SignUpViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.signUpView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.backgroundDartGrey
        self.navigationController?.navigationBar.topItem?.title = "뒤로가기"
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.signUpView.nextButton.rx.tap
            .bind(to: self.viewModel.input.tapNextButton)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToVerifyCode
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToVerifyCode)
            .disposed(by: disposeBag)
    }
    
    private func goToVerifyCode() {
        self.coordinator?.goToVerifyCode()
    }
}
