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
    func loadChatting(channel: Channel, communityId: Int?)
}

protocol DeliveryDelegate: AnyObject {
    func appear(channel: Channel?, communityId: Int?)
}

class HomeViewController: BaseViewController, CoordinatorContext {
    
    weak var coordinator: HomeCoordinator?
    
    weak var delegate: HomeViewControllerDelegate?
    weak var delivery: DeliveryDelegate?
    
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
    }
    
    private func addChildVCs() {
        // Menu VC
        menuViewController.coordinator = self.coordinator
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        menuViewController.delegate = self
        self.delivery = menuViewController.self
        
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
}

// MARK: - Data 동기화 (menu < - home - > chatting)
extension HomeViewController: MenuViewControllerDelegate {
    func swipe(channel: Channel?, communityId: Int) {
        self.didTapMenuButton(channel: channel, communityId: communityId) // 화면전환 애니메이션
        // delegate로 전달
        self.delegate?.loadChatting(channel: channel!, communityId: communityId)
    }
}

// MARK: - Menu Animation
extension HomeViewController: ChattingViewControllerDelegate {
    func dismiss(channel: Channel?, communityId: Int?) {
        self.menuState = .closed
        toggleMenu(completion: nil)
        self.delivery?.appear(channel: channel, communityId: communityId)
    }
    
    func didTapMenuButton(channel: Channel?, communityId: Int?) {
        toggleMenu(completion: nil)
        self.delivery?.appear(channel: channel, communityId: communityId)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .opened:
            self.tabBarController?.tabBar.isHidden = false
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
            self.tabBarController?.tabBar.isHidden = true
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

