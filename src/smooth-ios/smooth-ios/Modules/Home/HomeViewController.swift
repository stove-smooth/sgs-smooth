//
//  HomeViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift

class HomeViewController: BaseViewController {
    private let homeView = HomeView()
    private let viewModel = HomeViewModel(
        userDefaults: UserDefaultsUtil()
    )
    
    weak var coordinator: MainCoordinator?
    
    static func instance() -> HomeViewController {
        return HomeViewController(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func bindViewModel() {
        self.homeView.logOutButton.rx.tap
            .bind(to: self.viewModel.input.tapLogOutButton)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToSignin
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToSignIn)
            .disposed(by: disposeBag)
    }
    
    func goToSignIn() {
        self.coordinator?.goToSigIn()
    }
}

