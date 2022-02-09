//
//  JoinServerViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import Foundation

class JoinServerViewController: BaseViewController {
    weak var coordinator: AddServerCoordinator?
    
    private let joinView = JoinServerView()
    private let viewModel: JoinServerViewModel
    
    init() {
        self.viewModel = JoinServerViewModel(serverService: ServerService())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> JoinServerViewController {
        return JoinServerViewController()
    }
    
    override func loadView() {
        super.view = self.joinView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coordinator?.modalNav.isNavigationBarHidden = true
    }
    
    override func bindViewModel() {
        self.joinView.joinLinkField.rx.text
            .orEmpty
            .bind(onNext: { value in
                let baseURL = "https://yoloyolo.org/invite/c/"
                let code = value.replacingOccurrences(of: baseURL, with: "")
                self.viewModel.input.inputServerCode.on(.next(code))
            })
            .disposed(by: disposeBag)
        
        self.joinView.joinButton.rx.tap
            .bind(to: self.viewModel.input.tapJoinButton)
            .disposed(by: disposeBag)
        
        // MARK: 토스트 팝업 처리
        self.viewModel.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: true)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
        
    }
}
