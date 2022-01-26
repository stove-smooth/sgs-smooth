//
//  MakeServerViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import Foundation

class MakeServerViewContrller: BaseViewController {
    weak var coordinator: AddServerCoordinator?
    
    private let makeServerView = MakeServerView()
    
    static func instance() -> MakeServerViewContrller {
        return MakeServerViewContrller(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.view = self.makeServerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.makeServerView.privateButton.rx.tap
            .bind(onNext: {
                self.goToRegisterIcon(isPrivate: true)
            })
            .disposed(by: disposeBag)
        
        self.makeServerView.publicButton.rx.tap
            .bind(onNext: {
                self.goToRegisterIcon(isPrivate: false)
            })
            .disposed(by: disposeBag)
    }

    func goToRegisterIcon(isPrivate: Bool) {
        self.coordinator?.goToRegisterIcon(isPrivate: isPrivate)
    }
    
}
