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

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

enum MenuState {
    case opened
    case closed
}

class HomeViewController: BaseViewController, CoordinatorContext {
    
    weak var coordinator: HomeCoordinator?
    var navigationViewController: UINavigationController?
    
    private let menuViewController = MenuViewController.instance()
    private let containerViewController = ContainerViewController()
    lazy var serverViewController = ServerViewController()
    
    private var menuState: MenuState = .closed
    
    static func instance() -> HomeViewController {
        return HomeViewController(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // main nav 숨기기
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
    }
    
    private func addChildVCs() {
        // Menu VC
//        menuViewController.delegate = self
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Container VC
        containerViewController.delegate = self
        
        let navVC = UINavigationController(rootViewController: containerViewController)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        
        navVC.navigationBar.barTintColor = UIColor.backgroundDarkGray
        self.navigationViewController = navVC
    }
}

// MARK: - Menu Animation
extension HomeViewController: ContainerViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .opened:
            self.tabBarController?.tabBar.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut){
                self.navigationViewController?.view.frame.origin.x = self.containerViewController.view.frame.size
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
