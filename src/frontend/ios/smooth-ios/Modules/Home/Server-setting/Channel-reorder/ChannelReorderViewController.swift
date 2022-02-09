//
//  ChannelReorderViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/04.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class ChannelReorderViewController: UITableViewController {
    weak var coordinator: ServerSettingCoordinator?
    
    private let viewModel: ChannelReorderViewModel
    
    var model: Model
    let disposeBag = DisposeBag()

    init(categories: [Category]) {
        self.model = Model(categories: categories)
        self.viewModel = ChannelReorderViewModel(
            categories: categories,
            channelService: ChannelService()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(categories: [Category]) -> ChannelReorderViewController {
        return ChannelReorderViewController(categories: categories)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.coordinator?.modalNav.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        
        title = "채널 재배치"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(popup))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.rightBarButtonItem = nil
        navigationItem.hidesBackButton = false
    }
    
    func setupTableView() {
        tableView.backgroundColor = .messageBarDarkGray
        
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.register(ChannelReorderCell.self, forCellReuseIdentifier: ChannelReorderCell.identifier)
    }
    
    func bindViewModel() {
        self.viewModel.showErrorMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func popup() {
        navigationController?.popViewController(animated: false)
    }
    
    func showToast(message: String, isWarning: Bool) {
        var style = ToastStyle()
        style.backgroundColor = .serverListDarkGray!
        style.cornerRadius = 15
        
        let emoji = isWarning ? "⛔️ " : "✅ "
        
        self.view.makeToast(
            emoji+message,
            position: .top,
            style: style
        )
    }
    
}

// MARK: Model
extension ChannelReorderViewController {
    struct Model {
        private(set) var categories: [Category]
        
        init(categories: [Category]) {
            self.categories = categories
        }
        
        mutating func moveItem(at sourceIndex: IndexPath, to destinationIndex: IndexPath) {
            guard sourceIndex != destinationIndex else { return }
            
            var category = categories[sourceIndex.section]
            let movingChannels = categories[sourceIndex.section].channels![sourceIndex.row]
            
            // 카테고리 내 채널 이동
            if (sourceIndex.section == destinationIndex.section){
                category.channels!.remove(at: sourceIndex.row)
                category.channels!.insert(movingChannels, at: destinationIndex.row)
                categories[sourceIndex.section] = category
            } else {
            // 서로 다른 카테고리 간 채널 이동
                category.channels!.remove(at: sourceIndex.row)
                categories[sourceIndex.section] = category
                
                if categories[destinationIndex.section].channels == nil {
                    categories[destinationIndex.section].channels = [movingChannels]
                } else {
                    categories[destinationIndex.section].channels!.insert(movingChannels, at: destinationIndex.row)
                }
            }
        }
    }
}

// MARK: Data & Appearance
extension ChannelReorderViewController  {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelReorderCell.identifier, for: indexPath) as? ChannelReorderCell else { return BaseTableViewCell() }
        cell.bind(channel: self.model.categories[indexPath.section].channels![indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.categories[section].channels?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.model.categories.count
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { 
        return self.model.categories[section].name
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
    // move
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let categoryId = self.model.categories[destinationIndexPath.section].id
        let originId = model.categories[sourceIndexPath.section].channels![sourceIndexPath.row].id
        
        self.model.moveItem(at: sourceIndexPath, to: destinationIndexPath)
        
        
        let nextId = destinationIndexPath.row == 0 ? 0 : model.categories[destinationIndexPath.section].channels![destinationIndexPath.row-1].id
        
        self.viewModel.input.inputMoveIndex.onNext([originId, nextId, categoryId])
    }
}

// MARK: Drag
extension ChannelReorderViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = model.categories[indexPath.section].channels![indexPath.row]
        
        let itemProvider = NSItemProvider(object: "\(item.id.identity)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
