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
        
        self.viewModel.output.categories
            .asDriver(onErrorJustReturn: [])
            .drive(self.menuView.rx.categories)
            .disposed(by: disposeBag)
        
        menuView.serverView.tableView.rx.itemSelected
            .map { $0 }
            .bind(to: self.viewModel.input.tapServer)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToAddServer
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToAddServer)
            .disposed(by: disposeBag)
    }
    
    func goToAddServer() {
        self.coordinator?.goToAddServer()
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}

