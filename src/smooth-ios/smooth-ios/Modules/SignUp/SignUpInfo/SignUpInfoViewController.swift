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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        
    }
}
