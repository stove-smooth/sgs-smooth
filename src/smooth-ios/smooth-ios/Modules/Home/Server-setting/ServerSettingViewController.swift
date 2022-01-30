//
//  ServerSettingViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit
import RxSwift
import RxCocoa

class ServerSettingViewController: BaseViewController {
    weak var coordinator: HomeCoordinator?
    
    private var settingView = ServerSettingView()
    private let viewModel: ServerSettingViewModel
    
    let server: Server
    
    init(server: Server) {
        self.server = server
        self.viewModel = ServerSettingViewModel(server: server, serverRepository: ServerRepository())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(server: Server) -> UINavigationController {
        let settingVC = ServerSettingViewController(server: server)
        
        return UINavigationController(rootViewController: settingVC).then {
            $0.modalPresentationStyle = .overCurrentContext
            $0.isNavigationBarHidden = true
        }
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        super.view = self.settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        
    }
}
