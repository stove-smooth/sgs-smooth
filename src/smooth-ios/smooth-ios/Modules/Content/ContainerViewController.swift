//
//  ContainerViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import Then

protocol ContainerViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class ContainerViewController: BaseViewController, CoordinatorContext {
    
    weak var coordinator: HomeCoordinator?
    weak var delegate: ContainerViewControllerDelegate?
    
    static func instance() -> ContainerViewController {
        return ContainerViewController(nibName: nil, bundle: nil)
    }
    
    let tableView = UITableView(frame: .zero, style: .plain) //1
    var items = ["내용", "날짜", "시간", "위치"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .messageBarDarkGray
        self.tabBarController?.tabBar.isHidden = true
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Menu")?.resizeImage(size: CGSize(width: 25, height: 25)),
            style: .done,
            target: self,
            action: #selector(didTapMenuButton)
        )
        navigationController?.title = "컨테이너 뷰"

        self.setupTableView()
    }
    
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
        
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    
}

extension ContainerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
}
