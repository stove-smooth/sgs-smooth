//
//  FriendViewController.swift
//  smooth-ios
//
//  Created by durikim-MN on 2022/01/14.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

extension FriendListViewController: FriendRequestDelegate {
    func onClose() {
        self.viewModel.fetchFriend()
    }
}

class FriendListViewController: BaseViewController, CoordinatorContext {
    weak var coordinator: FriendCoordinator?
    var navigationViewController: UINavigationController?
    
    private let friendListView = FriendListView()
    private let viewModel: FriendListViewModel
    
    var dataSource: friendDataSource!
    
    init() {
        self.viewModel = FriendListViewModel(friendService: FriendService())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> FriendListViewController {
        return FriendListViewController()
    }
    
    override func loadView() {
        self.view = self.friendListView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.viewModel.fetchFriend()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        self.setupTableView()
        view = friendListView
        
        super.viewDidLoad()
    }
    
    private func setupTableView() {
        friendListView.tableView.register(FriendListViewCell.self, forCellReuseIdentifier: FriendListViewCell.identifier)
        friendListView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        friendListView.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.dataSource = friendDataSource(
            configureCell: { dataSource, tableView, indexPath, cellType in
                switch cellType {
                case .empty:
                    // return empty cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: FriendListViewCell.identifier, for: indexPath)
                    return cell
                    
                case .normal(let friend):
                    let cell = tableView.dequeueReusableCell(withIdentifier: FriendListViewCell.identifier, for: indexPath) as! FriendListViewCell
                    
                    cell.bind(friend: friend)
                    
                    // MARK: - cell Binding
                    cell.rejectButton.rx.tap
                        .asDriver()
                        .drive(onNext: { [weak self] in
                            self?.viewModel.input.tapRejectButton.accept(friend)
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.acceptButton.rx.tap
                        .asDriver()
                        .drive(onNext: { [weak self] in
                            self?.viewModel.input.tapAcceptButton.accept(friend)
                        })
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                }
            },
            titleForHeaderInSection: {dataSource, index in
                return "\(dataSource.sectionModels[index].header) - \(dataSource.sectionModels[index].items.count)"
            }
        )
    }
    
    override func bindEvent() {
        self.friendListView.tabBarView.homeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.coordinator?.goToMain()
            })
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        viewModel.output.sections
            .bind(to: friendListView.tableView.rx.items(dataSource: self.dataSource!))
            .disposed(by: disposeBag)
        
        friendListView.tableView.rx.modelSelected(FriendCellType.self)
            .subscribe(onNext:  { cell in
                switch cell {
                case .empty:
                    break
                case .normal(let friend):
                    print(friend)
                    self.coordinator?.showFriendInfoModal(id: friend.id, state: friend.state)
                }
            })
            .disposed(by: disposeBag)
        
        friendListView.requestButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToRequeset)
            .disposed(by: disposeBag)
        
        friendListView.emptyView.requestButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToRequeset)
            .disposed(by: disposeBag)
        
        viewModel.output.showLoading
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.friendListView.showLoading(isShow:))
            .disposed(by: disposeBag)
        
        viewModel.output.showEmpty
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.friendListView.showEmpty(isShow:))
            .disposed(by: disposeBag)
        
    }
    
    private func goToRequeset() {
        self.coordinator?.goToRequest()
    }
}

extension FriendListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}
