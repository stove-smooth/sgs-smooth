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

    static func instance() -> JoinServerViewController {
        return JoinServerViewController(nibName: nil, bundle: nil)
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
        
    }
}
