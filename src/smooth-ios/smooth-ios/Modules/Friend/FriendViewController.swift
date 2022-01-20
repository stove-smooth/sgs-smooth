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

class FriendViewController: BaseViewController, CoordinatorContext {
    weak var coordinator: FriendCoordinator?
    var navigationViewController: UINavigationController?
    private let viewModel = FriendViewModel()
    
    
    var friends: [Friend]?
    let tableView = UITableView(frame: .zero, style: .plain)

    static func instance() -> FriendViewController {
        return FriendViewController(nibName: nil, bundle: nil)
    }
    
    lazy var dataSource = friendDataSource(
      configureCell: { dataSource, tableView, indexPath, cellType in
          switch cellType {
          case .empty:
              // return empty cell
              let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath)
            return cell
              
          case .normal(let friend):
              let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.identifier, for: indexPath) as! FriendCell
              
              cell.ui(friend: friend)
              
              cell.rejectButton.rx.tap
                  .asDriver()
                  .drive(onNext: { [weak self] in
                      print("rejectButton \(friend)")
                      self?.viewModel.output.tapRejectButton.accept(friend)
                  })
                  .disposed(by: cell.disposeBag)
              
            return cell
          }
    },
      titleForHeaderInSection: {dataSource, index in
          return "\(dataSource.sectionModels[index].header) - \(dataSource.sectionModels[index].items.count)"
      }
    )
    
    func setupTableView() {
        tableView.register(FriendCell.self, forCellReuseIdentifier: FriendCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)

         tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.input.getFriendList.onNext(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "친구"
        view.backgroundColor = .messageBarDarkGray
        
        self.setupTableView()
        self.viewModel.input.viewDidLoad.onNext(())
    }
    
    override func bindViewModel() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        /*
        tableView.rx.itemSelected
        .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        let data = self.roomViewModel.data
        print("\(indexPath.row)번째 Cell: \(data[indexPath.row])")
        
        // todos: 선택 시 channel viewModel에게 이벤트 방출
        })
        .disposed(by: disposeBag)
        */
        
        tableView.rx.modelSelected(FriendCellType.self)
                .subscribe(onNext:  { item in
                    print("\(item)")
                })
                .disposed(by: disposeBag)

        self.viewModel.input.viewDidLoad
            .debug()
            .subscribe { _ in
                self.viewModel.loadFriend()
            }
            .disposed(by: disposeBag)
        
//        self.viewModel.output.goToRequest
//            .observe(on: MainScheduler.instance)
//            .bind(onNext: self.goToRequeset)
//            .disposed(by: disposeBag)
        
        self.viewModel.output.tapRejectButton
            .subscribe(onNext: { friend in
                
                
                guard let friend = friend else {
                    return
                }

                FriendRepository.deleteFriend(DeleteFriendRequest(id: friend.id)) { response, _  in
                    self.viewModel.loadFriend()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func goToRequeset() {
        self.coordinator?.goToRequest()
    }
}

extension FriendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}
