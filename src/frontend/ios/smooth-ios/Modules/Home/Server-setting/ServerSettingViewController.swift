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
    weak var coordinator: ServerSettingCoordinator?
    
    private var settingView = ServerSettingView()
    private let viewModel: ServerSettingViewModel
    
    let server: Server
    
    init(server: Server) {
        self.server = server
        self.viewModel = ServerSettingViewModel(server: server, serverService: ServerService())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(server: Server) -> ServerSettingViewController {
        return ServerSettingViewController(server: server)
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
//        self.coordinator?.goToMain()
    }
    
    override func loadView() {
        super.view = self.settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingView.tableView.delegate = self
        self.settingView.tableView.dataSource = self
    }
    
    override func bindViewModel() {
        self.settingView.closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.dismiss)
            .disposed(by: disposeBag)
    }
}

extension ServerSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ServerSettingCell.identifier,
            for: indexPath
        ) as? ServerSettingCell else { return BaseTableViewCell() }
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.bind(image: UIImage(systemName: "info.circle")!.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal), title: "일반")
            case 1:
                cell.bind(image: UIImage(systemName: "text.alignleft")!.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal), title: "채널")
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.bind(image: UIImage(systemName: "person.2.fill")!.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal), title: "멤버")
            case 1:
                cell.bind(image: UIImage(systemName: "link")!.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal), title: "초대")
            case 2:
                cell.bind(image: UIImage(systemName: "x.circle")!.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal), title: "차단")
            default:
                break
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ServerSettingHeaderCell.identifier) as? ServerSettingHeaderCell else { return UITableViewHeaderFooterView() }
        
        if section == 0 {
            headerCell.bind(title: "설정")
        } else {
            headerCell.bind(title: "사용자 관리")
        }
        
        return headerCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: // 일반
                self.coordinator?.goToEditServerInfo(server: self.server)
            case 1: // 채널
                self.coordinator?.goToChannel(server: self.server)
            default: break
            }
        } else {
            switch indexPath.row {
            case 0:
                // 멤버
                break
            case 1:
                // 초대
                self.coordinator?.goToInvite(server: self.server)
            default: break
            }
        }
    }
}
