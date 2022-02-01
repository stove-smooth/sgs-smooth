//
//  ContainerViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import Then

protocol ChattingViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class ChattingViewController: BaseViewController {
    
    weak var coordinator: HomeCoordinator?
    weak var delegate: ChattingViewControllerDelegate?
    
    private let chattingView = ChattingView()
    private let viewModel: ChattingViewModel
    
    static func instance() -> ChattingViewController {
        return ChattingViewController()
    }
    
    init() {
        self.viewModel = ChattingViewModel(chattingRepository: ChattingRepository())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let tableView = UITableView(frame: .zero, style: .plain) //1
    var items = ["내용", "날짜", "시간", "위치"]
    
    override func loadView() {
        super.view = self.chattingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        
        super.viewWillAppear(animated)
    }

    
    override func bindEvent() {
        self.chattingView.menuButton.rx.tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: { _ in
            self.delegate?.didTapMenuButton()
            })
            .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        self.viewModel.output.channel
            .bind(onNext: { channel in
                self.chattingView.bind(channel: channel)
                
                // MARK: 잠시 주석 self.viewModel.input.fetch.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
//    func setupNavigation() {
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            image: UIImage(named: "Menu")?.resizeImage(size: CGSize(width: 25, height: 25)),
//            style: .done,
//            target: self,
//            action: #selector(didTapMenuButton)
//        )
//    }
//
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
       
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
}

extension ChattingViewController: HomeViewControllerDelegate {
    func loadChatting(channel: Channel) {
        self.viewModel.output.channel.accept(channel)
    }
}

