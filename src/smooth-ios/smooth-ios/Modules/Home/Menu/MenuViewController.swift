//
//  MeneViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift
import RxCocoa

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuViewController.MenuOptions)
}

extension UIEdgeInsets {
    static func all(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    static func symmetric(vertical: CGFloat, horizontal: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

class MenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: MenuViewControllerDelegate?
    
    let refreshControl = UIRefreshControl()
    
    let generateButton = UIButton().then {
        $0.setTitle("1️⃣", for: .normal)
    }
    
    let showAllButton = UIButton().then {
        $0.setTitle("2️⃣", for: .normal)
    }
    
    let removeAllButton = UIButton().then {
        $0.setTitle("3️⃣", for: .normal)
    }
    
    let value = PublishSubject<(id: UUID, value: Int)>()
    let selectedChanged = PublishSubject<(id: UUID, selected: Bool)>()
    let delete = PublishSubject<UUID>()
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case chat = "chat"
        case addServer = "add_server"
    }
    
    static func instance() -> MenuViewController {
        return MenuViewController(nibName: nil, bundle: nil)
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = nil
        table.separatorStyle = .none
        return table
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ServerListView, ServerContentView])
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var ServerListView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.serverListDartGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var ServerContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .serverListDartGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            generateButton,
            showAllButton,
            removeAllButton
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        return stackView
    }()
    
    lazy var layout: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [tableView, collectionView])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .serverListDartGray
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        collectionView.contentInset = UIEdgeInsets.all(20)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
        view.addSubview(layout)
        setupLayout()
    }
    
    func setupLayout() {
        // Stack View
        
        layout.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(view.snp.width).offset(-50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(layout.snp.top)
            make.width.equalTo(80)
        }
        
    }
    
    let repository = Repository()
    
    override func bindViewModel() {
        
        let value = self.value
        let delete = self.delete
        let selectedChanged = self.selectedChanged
        
        let addInput = Observable.merge(
            rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in },
            refreshControl.rx.controlEvent(.valueChanged).delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance).asObservable(),
            generateButton.rx.tap.asObservable()
        )
        
        let input = Input(value: value, selectedChanged: selectedChanged, add: addInput, delete: delete)
        
        let viewModel = ViewModel(input, refreshTask: self.repository.refreshValues)
        
        viewModel.counters
            .drive(collectionView.rx.items(cellIdentifier: CollectionViewCell.identifier, cellType: CollectionViewCell.self)) { index, element, cell in
                cell.configure(with: { input in
                    let vm = CellViewModel(input, initialValue: element)
                    // Remember the value property tracks the current value of the counter
                    vm.value
                        .map { (id: element.id, value: $0) } // tell the main view model which counter's value this is
                        .bind(to: value)
                        .disposed(by: cell.bag)
                    
                    vm.selectedChanged
                        .map { (id: element.id, selected: $0)}
                        .bind(to: selectedChanged)
                        .disposed(by: cell.bag)

                    vm.delete
                        .map { element.id } // tell the main view model which counter should be deleted
                        .bind(to: delete)
                        .disposed(by: cell.bag)
                    return vm // hand the cell view model to the cell
                })
            }.disposed(by: disposeBag)
        
        viewModel.counters
            .map { _ in false }
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)
    }

    // table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }
}


class CustomCell: UITableViewCell {
    static var identifier: String { return "\(self)" }
    
    let name = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ui()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ui() {
        self.addSubview(name)
        
        name.translatesAutoresizingMaskIntoConstraints = false
//        name.widthAnchor.constraint(equalToConstant: 60)

    }
}



extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.inset(by: collectionView.contentInset).width, height: 70)
    }
}

class CollectionViewCell: UICollectionViewCell {
    static var identifier: String { return "\(self)" }

    var bag = DisposeBag()

    let label = UILabel()
    let plus = UIButton().then {$0.setTitle("plus", for: .normal)}
    let minus = UIButton().then {$0.setTitle("minus", for: .normal)}
    let delete = UIButton().then {$0.setTitle("delete", for: .normal)}
    let check = UIButton().then {$0.setTitle("check", for: .normal)}

    override init(frame: CGRect) {
        super.init(frame: frame)
        ui()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func ui() {
        self.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
        self.layoutMargins = UIEdgeInsets.symmetric(vertical: 8, horizontal: 12)
        
        let stackButtons = UIStackView(arrangedSubviews: [
            UIView(),
            plus,
            minus,
            check,
            delete
            ])
        stackButtons.axis = .horizontal
        stackButtons.alignment = .center
        stackButtons.distribution = .fill
        stackButtons.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [
            label,
            stackButtons
            ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.margins)
        }
    }

    func configure(with factory: @escaping (CellInput) -> CellViewModel) {
        // create the input object
        let input = CellInput(
            plus: plus.rx.tap.asObservable(),
            minus: minus.rx.tap.asObservable(),
            select: check.rx.tap.asObservable(),
            delete: delete.rx.tap.asObservable()
        )
        // create the view model from the factory
        let viewModel = factory(input)
        // bind the view model's label property to the label
        viewModel.label
            .bind(to: label.rx.text)
            .disposed(by: bag)
        
        viewModel.selected
            .bind(to: check.rx.isSelected)
            .disposed(by: bag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
