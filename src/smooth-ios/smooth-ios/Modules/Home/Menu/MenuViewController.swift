//
//  MeneViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MenuViewController: BaseViewController, CoordinatorContext {
    weak var coordinator: HomeCoordinator?
    private lazy var menuView = MenuView(frame: self.view.frame)
    private let viewModel: MenuViewModel
    
    init() {
        self.viewModel = MenuViewModel(serverRepository: ServerRepository())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> MenuViewController {
        return MenuViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.input.fetch.onNext(())
    }
    
    override func viewDidLoad() {
        self.view = menuView
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
        self.viewModel.output.servers
            .asDriver(onErrorJustReturn: [])
            .drive(self.menuView.rx.server)
            .disposed(by: disposeBag)
    }
    
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}

