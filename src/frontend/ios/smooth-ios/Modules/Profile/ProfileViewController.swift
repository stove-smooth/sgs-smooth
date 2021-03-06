//
//  ProfileViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/14.
//

import UIKit
import RxSwift

class ProfileViewController: BaseViewController {
    weak var coordinator: ProfileCoordinator?
    
    private let profileView = ProfileView()
    private let viewModel: ProfileViewModel
    
    init() {
        self.viewModel = ProfileViewModel(
            userService: UserService(),
            userDefaults: UserDefaultsUtil()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> ProfileViewController {
        return ProfileViewController()
    }
    
    override func loadView() {
        view = self.profileView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.input.fetch.onNext(())
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.input.fetch.onNext(())
        
        self.profileView.tableView.delegate = self
        self.profileView.tableView.dataSource = self
    }
    
    override func bindEvent() {
        self.profileView.tabBarView.homeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.coordinator?.goToMain()
            })
            .disposed(by: disposeBag)
        
        self.profileView.tabBarView.friendButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.coordinator?.goToFriend()
            })
            .disposed(by: disposeBag)
        
        self.profileView.tabBarView.profileButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.coordinator?.start()
            })
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        self.profileView.logoutButton.rx.tap
            .bind(to: self.viewModel.input.tapLogoutButton)
            .disposed(by: disposeBag)
        
        
        self.viewModel.output.user
            .bind(onNext: { user in
                self.profileView.bind(user: user)
            }).disposed(by: disposeBag)
        
        self.viewModel.output.goToLoginHome
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.coordinator?.goToLoginHome()
            })
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ServerSettingCell.identifier,
            for: indexPath
        ) as? ServerSettingCell else { return BaseTableViewCell() }
        
        
        switch indexPath.row {
        case 0:
            cell.bind(image: UIImage(), title: "상태 설정")
        case 1:
            cell.bind(image: UIImage(), title: "사용자 프로필")
        default: break
        }
        
        cell.layer.borderColor = UIColor.serverListDarkGray?.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1: // 사용자 프로필
            self.coordinator?.goToEdit(user: self.viewModel.model.user!)
        default: break
        }
    }
}
