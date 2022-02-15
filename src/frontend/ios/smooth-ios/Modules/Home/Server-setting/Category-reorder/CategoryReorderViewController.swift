//
//  CategoryReorderViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class CategoryReorderViewController: UITableViewController {
    weak var coordinator: ServerSettingCoordinator?
    
    private let viewModel: CategoryReorderViewModel
    
    var model: Model
    let disposeBag = DisposeBag()

    init(categories: [Category]) {
        self.model = Model(categories: categories)
        self.viewModel = CategoryReorderViewModel(
            categories: categories,
            categoryService: CategoryService()
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(categories: [Category]) -> CategoryReorderViewController {
        return CategoryReorderViewController(categories: categories)
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
        tableView.register(CategoryReorderCell.self, forCellReuseIdentifier: CategoryReorderCell.identifier)
    }
    
    func bindViewModel() {
        self.viewModel.showToastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { message in
                self.showToast(message: message, isWarning: false)
            })
            .disposed(by: disposeBag)
        
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
extension CategoryReorderViewController {
    struct Model {
        private(set) var categories: [Category]
        
        init(categories: [Category]) {
            self.categories = categories
        }
        
        mutating func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
            guard sourceIndex != destinationIndex else { return }
            
            let category = categories[sourceIndex]
            categories.remove(at: sourceIndex)
            categories.insert(category, at: destinationIndex)
        }
    }
}

// MARK: Data
extension CategoryReorderViewController  {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryReorderCell.identifier, for: indexPath) as? CategoryReorderCell else { return BaseTableViewCell() }
        cell.bind(title: model.categories[indexPath.row].name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.categories.count
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let originId = model.categories[sourceIndexPath.row].id
        self.model.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
        let nextId = destinationIndexPath.row == 0 ? 0 : model.categories[destinationIndexPath.row-1].id
        self.viewModel.input.inputMoveIndex.onNext([originId, nextId])
    }
}

// MARK: Drag
extension CategoryReorderViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = model.categories[indexPath.row]
        
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
