//
//  HomeViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

enum MenuState {
    case opened
    case closed
}

protocol HomeViewControllerDelegate: AnyObject {
    func loadChatting(_ chatName: String, channelId: Int, communityId: Int?)
}

class HomeViewController: BaseViewController, CoordinatorContext {
    
    weak var coordinator: HomeCoordinator?
    
    private let tabBarView = TabBarView()
    
    weak var delegate: HomeViewControllerDelegate?
    
    var navigationViewController: UINavigationController?
    
    private let menuViewController = MenuViewController.instance()
    private let chattingViewController = ChattingViewController()
    
    private var menuState: MenuState = .closed
    
    static func instance() -> HomeViewController {
        return HomeViewController(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
        
        self.tabBarView.setItem(tag: .home)
        view.addSubview(tabBarView)
        
        
        tabBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
    
    private func addChildVCs() {
        // Menu VC
        menuViewController.coordinator = self.coordinator
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        menuViewController.delegate = self
        
        // chatting VC
        chattingViewController.delegate = self
        chattingViewController.coordinator = self.coordinator
        self.delegate = chattingViewController.self
        
        let navVC = UINavigationController(rootViewController: chattingViewController)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        
        navVC.navigationBar.barTintColor = UIColor.backgroundDarkGray
        self.navigationViewController = navVC
    }
    
    override func bindEvent() {
        self.tabBarView.homeButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.coordinator?.start()
            })
            .disposed(by: disposeBag)
        
        self.tabBarView.friendButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.coordinator?.goToFriend()
            })
            .disposed(by: disposeBag)
        
        self.tabBarView.profileButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.coordinator?.goToProfile()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Data 동기화 (menu < - home - > chatting)
extension HomeViewController: MenuViewControllerDelegate {
    func swipe(_ chatName: String, channelId: Int?, communityId: Int?) {
        self.didTapMenuButton(channelId: channelId, communityId: communityId) // 화면전환 애니메이션
        // delegate로 전달
        self.delegate?.loadChatting(chatName, channelId: channelId!, communityId: communityId)
    }
}

// MARK: - Menu Animation
extension HomeViewController: ChattingViewControllerDelegate {
    func dismiss(channelId: Int?, communityId: Int?) {
        self.menuState = .closed
        toggleMenu(completion: nil)
        
    }
    
    func didTapMenuButton(channelId: Int?, communityId: Int?) {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .opened:
            self.tabBarView.isHidden = false
            self.chattingViewController.messageInputBar.isHidden = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut){
                self.navigationViewController?.view.frame.origin.x = self.chattingViewController.view.frame.size
                    .width-50
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }
            
        case .closed:
            self.tabBarView.isHidden = true
            self.chattingViewController.messageInputBar.isHidden = false
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut){
                self.navigationViewController?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .opened
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
            
        }
    }
}

