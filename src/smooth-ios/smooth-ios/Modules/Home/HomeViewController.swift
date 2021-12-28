//
//  HomeViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: BaseViewController {
    
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    private let homeView = HomeView()
    private let viewModel = HomeViewModel(
        userDefaults: UserDefaultsUtil()
    )
    
    weak var coordinator: MainCoordinator?
    
    private let menuViewController = MenuViewController()
    private let containerViewController = ContainerViewController()
    lazy var serverViewController = ServerViewController()
    
    var navigationViewController: UINavigationController?
    
    
    static func instance() -> HomeViewController {
        return HomeViewController(nibName: nil, bundle: nil)
    }
    
    //    override func loadView() {
    //        self.view = self.homeView
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
    }
    
    private func addChildVCs() {
        // Menu VC
        menuViewController.delegate = self
        addChild(menuViewController)
        view.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: self)
        
        // Container VC
        containerViewController.delegate = self
        let navVC = UINavigationController(rootViewController: containerViewController)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navigationViewController = navVC
    }
    
    override func bindViewModel() {
        self.homeView.logOutButton.rx.tap
            .bind(to: self.viewModel.input.tapLogOutButton)
            .disposed(by: disposeBag)
        
        self.viewModel.output.goToSignin
            .debug()
            .observe(on: MainScheduler.instance)
            .bind(onNext: self.goToSignIn)
            .disposed(by: disposeBag)
    }
    
    func goToSignIn() {
        self.coordinator?.goToSigIn()
    }
}


extension HomeViewController: ContainerViewControllerDelegate {
    func didTapMenuButton() {
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut){
                
                self.navigationViewController?.view.frame.origin.x = self.containerViewController.view.frame.size
                    .width-50
            } completion: { [weak self] done in
                if done {
                    self?.menuState = .closed
                }
            }
            
        case .closed:
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

extension HomeViewController: MenuViewControllerDelegate {
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        
        switch menuItem {
        case .home:
            self.resetToHome()
        default:
            // MARK menuItem(룸 서버) 정보 전달
            self.addServer()
        }
    }
    
    func addServer() {
        let vc = serverViewController
        
        containerViewController.addChild(vc)
        containerViewController.view.addSubview(vc.view)
        
        vc.view.frame = view.frame
        vc.didMove(toParent: containerViewController)
        containerViewController.title = vc.title
    }
    
    func resetToHome() {
        // child 삭제
        serverViewController.willMove(toParent: nil)
        serverViewController.removeFromParent()
        serverViewController.view.removeFromSuperview()
        
        containerViewController.view.frame = view.frame
        containerViewController.didMove(toParent: nil)
        
        containerViewController.title = "Container ViewController"
    }
}
