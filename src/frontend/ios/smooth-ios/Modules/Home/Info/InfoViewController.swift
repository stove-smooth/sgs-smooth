//
//  InfoViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/17.
//

import UIKit
import PanModal

class InfoViewController: BaseViewController {
    weak var coordinator: HomeCoordinator?
    
    private let infoView = InfoView()
    private let viewModel: InfoViewModel
    
    init(isGroup: Bool, id: Int) {
        self.viewModel = InfoViewModel(
            isGroup: isGroup,
            id: id,
            serverService: ServerService()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    static func instance(isGroup: Bool, id: Int) -> InfoViewController {
        return InfoViewController(isGroup: isGroup, id: id)
    }
    
    override func loadView() {
        view = self.infoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.input.viewDidLoad.onNext(())
    }
    
    override func bindViewModel() {
        self.viewModel.output.members
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { members in
                self.infoView.bind(members: members)
            })
            .disposed(by: disposeBag)
    }
}
