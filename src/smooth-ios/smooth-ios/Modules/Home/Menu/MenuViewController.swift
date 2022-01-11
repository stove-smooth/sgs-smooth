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

class MenuViewController: BaseViewController{
    weak var delegate: MenuViewControllerDelegate?
    
    // MARK: - viewModel
    let serverViewModel = ServerViewModel()
    let channelViewModel = ChannelViewModel()
    
    let value = PublishSubject<(id: UUID, value: Int)>()
    let selectedChanged = PublishSubject<(id: UUID, selected: Bool)>()
    
    enum MenuOptions: String, CaseIterable {
        case home = "Home"
        case chat = "chat"
        case addServer = "add_server"
    }
    
    static func instance() -> MenuViewController {
        return MenuViewController(nibName: nil, bundle: nil)
    }
    
    private var channelView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .messageBarDarkGray
        collectionView.layer.cornerRadius = 10
        collectionView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        collectionView.contentInset = UIEdgeInsets.all(20)
//        collectionView.lay
        collectionView.register(ChannelCell.self, forCellWithReuseIdentifier: ChannelCell.identifier)
        return collectionView
    }()
    
    private let tableView = UITableView().then {
        $0.backgroundColor = nil
        $0.separatorStyle = .none
        $0.rowHeight = 80

        $0.cellLayoutMarginsFollowReadableWidth = true
        
        $0.separatorInsetReference = .fromAutomaticInsets
        
        $0.register(ServerCell.self, forCellReuseIdentifier: ServerCell.identifier)
    }
    
    lazy var layout: UIStackView = {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(tableView)
        stackView.setCustomSpacing(5, after: tableView)
        stackView.addArrangedSubview(channelView)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .serverListDartGray
        
        view.addSubview(layout)
        
        // MARK: - setupLayout
        layout.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.bottom)
            $0.width.equalTo(view.snp.width).offset(-50)
        }
        
        tableView.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
//        channelView.snp.makeConstraints {
//            $0.top.equalTo(view.snp.top)
//            $0.top.bottom.equalTo(self.view)
//        }
    }
    
    override func bindViewModel() {
        // MARK: - channels Bindings
        Observable.just(serverViewModel.data)
            .bind(to: channelView.rx.items(cellIdentifier: ChannelCell.identifier, cellType: ChannelCell.self)) { index, value, cell in
                cell.label.text = "index \(index) \(value)"
                
            }.disposed(by: disposeBag)
        
            
        channelView.rx.modelSelected(String.self)
            .subscribe(onNext: { model in
                print("\(model) was selected")
            })
            .disposed(by: disposeBag)
        
        // MARK: - server Bindings
        Observable.just(serverViewModel.data)
            .bind(to: tableView.rx.items) { tableView, row, item in
                let indexPath = IndexPath.init(item: row, section: 0)
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ServerCell.identifier, for: indexPath)
                let data = self.serverViewModel.data
                
                cell.layer.cornerRadius = 30
                cell.layer.masksToBounds = true
                
                cell.backgroundColor = .blurple
                cell.textLabel?.text = data[indexPath.row]
                
                return cell
            }.disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .subscribe(onNext: { [weak self] (indexPath, String) in
                guard let self = self else { return }
                
                self.tableView.deselectRow(at: indexPath, animated: false)
                
                self.channelViewModel.input.fetchServer
                    .accept(self.serverViewModel.data[indexPath.row])
            })
            .disposed(by: disposeBag)
        
        // server 아이콘을 선택한 경우
        /* 🚀tableView Rx Binding
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let data = self.roomViewModel.data
                print("\(indexPath.row)번째 Cell: \(data[indexPath.row])")
                
                // todos: 선택 시 channel viewModel에게 이벤트 방출
            })
            .disposed(by: disposeBag)
        */
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.inset(by: collectionView.contentInset).width, height: 70)
    }
}
