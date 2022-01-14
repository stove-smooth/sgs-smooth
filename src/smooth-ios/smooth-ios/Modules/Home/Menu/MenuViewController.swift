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

struct Channel: Codable, Equatable, IdentifiableType {
    var id: String
    var name: String
    var identity: String {
        return self.id
    }
}

struct ChannelSection {
    var header: String
    var items: [Item]
    var identity: String
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
        self.identity = UUID().uuidString
    }
}

extension ChannelSection: AnimatableSectionModelType {
    typealias Item = Channel
    
    init(original: ChannelSection, items: [Channel]) {
        self = original
        self.items = items
    }
}

class MenuViewController: BaseViewController, CoordinatorContext {
    weak var coordinator: HomeCoordinator?
    
    typealias channelDataSource = RxTableViewSectionedReloadDataSource<ChannelSection>
    
    let dataSource: channelDataSource = {
        let ds = channelDataSource(
            configureCell: { dataSource, tableView, indexPath, channel -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier, for: indexPath) as? ChannelCell else { return UITableViewCell() }
                cell.backgroundColor = .messageBarDarkGray
                cell.textLabel?.text = "\(dataSource[indexPath].name)"
                cell.textLabel?.textColor = .white
                cell.tintColor = .white
                
                return cell
            }
        )
        
        ds.titleForHeaderInSection = { dataSource, index in
            return "channel - \(dataSource.sectionModels[index].header)"
        }
        
        ds.canEditRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        ds.canMoveRowAtIndexPath = { dataSource, indexPath in
            return true
        }
        
        return ds
    }()
    
    
    // MARK: - viewModel
    let serverViewModel = ServerViewModel()
    let channelViewModel = ChannelViewModel()
    
    let value = PublishSubject<(id: UUID, value: Int)>()
    let selectedChanged = PublishSubject<(id: UUID, selected: Bool)>()
    
    static func instance() -> MenuViewController {
        return MenuViewController(nibName: nil, bundle: nil)
    }
    
    private var channelView = UITableView().then {
        $0.backgroundColor = .messageBarDarkGray
        
        $0.layer.cornerRadius = 10
        $0.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.cellLayoutMarginsFollowReadableWidth = true
        $0.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.identifier)
    }
    
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
    
    let sections = [
        ChannelSection(header: "first", items: [
            Channel(id: "1", name: "a"),
            Channel(id: "2", name: "b"),
            Channel(id: "3", name: "c")
        ]),
        ChannelSection(header: "second", items: [
            Channel(id: "1", name: "a"),
            Channel(id: "2", name: "b"),
            Channel(id: "3", name: "c")
        ]),
        ChannelSection(header: "third", items: [
            Channel(id: "1", name: "a"),
            Channel(id: "2", name: "b"),
            Channel(id: "3", name: "c")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .serverListDartGray
        view.addSubview(layout)
        
        // MARK: - setupLayout
        layout.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.bottom)
            $0.width.equalTo(view.snp.width).offset(-50)
            $0.trailing.equalTo(view.snp.trailing).offset(-60)
        }
        
        tableView.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
    }
    
    private func goToContainer(channel: Channel) {
        self.coordinator?.goToContainer()
    }
    
    override func bindViewModel() {
        // MARK: - channels Bindings
        channelView.rx.setDelegate(self).disposed(by: disposeBag)
        
        Observable.just(sections)
            .bind(to: channelView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        channelView.rx.modelSelected(Channel.self)
            .observe(on: MainScheduler.instance)
            .bind(onNext: { model in
                // TODO: - contentView Bindign
                self.goToContainer(channel: model)
            })
            .disposed(by: disposeBag)
        
        // MARK: - server Bindings
        Observable.just(serverViewModel.data)
            .bind(to: tableView.rx.items) { tableView, row, item in
                let indexPath = IndexPath.init(item: row, section: 0)

                guard let cell = tableView.dequeueReusableCell(withIdentifier: ServerCell.identifier, for: indexPath) as? ServerCell else { return UITableViewCell() }
                let data = self.serverViewModel.data
                
                cell.ui(data: data[indexPath.row])
                
                return cell
            }.disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .subscribe(onNext: { [weak self] (indexPath, String) in
                guard let self = self else { return }
                
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

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}

