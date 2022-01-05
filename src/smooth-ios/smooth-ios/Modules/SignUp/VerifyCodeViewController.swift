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
    private let viewModel = VerifyCodeViewModel()
    
    
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
        
    }
}
