//
//  AddServerViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class AddServerViewController: BaseViewController {
    weak var coordinator: AddServerCoordinator?
    
    private let addServerView = AddServerView()
    
    static func instance() -> AddServerViewController {
        return AddServerViewController(nibName: nil, bundle: nil)
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
        self.coordinator?.goToMain()
    }
    
    override func loadView() {
        super.view = self.addServerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.addServerView.closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
        
        self.addServerView.makeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToMake)
            .disposed(by: disposeBag)
        
        self.addServerView.joinButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToJoin)
            .disposed(by: disposeBag)
    }
    
    func goToJoin() {
        self.coordinator?.goToJoin()
    }
    
    func goToMake() {
        self.coordinator?.goToMake()
    }
}
