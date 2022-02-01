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
    func loadChatting(channel: Channel)
}

class HomeViewController: BaseViewController, CoordinatorContext {
    
    weak var coordinator: HomeCoordinator?
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
    func swipe(channel: Channel?) {
        self.didTapMenuButton() // 화면전환 애니메이션
        // delegate로 전달
        self.delegate?.loadChatting(channel: channel!)
    }
}

// MARK: - Menu Animation
extension HomeViewController: ChattingViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .opened:
            self.tabBarController?.tabBar.isHidden = false
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

