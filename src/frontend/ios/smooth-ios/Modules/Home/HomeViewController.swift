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
    func loadChatting(_ chatName: String, channelId: Int, communityId: Int?, isWebRTC: Bool)
}

// MARK: - Menu Animation
extension HomeViewController: ChattingViewControllerDelegate {
    func didTapMenuButton(channelId: Int?, communityId: Int?, isWebRTC: Bool) {
        self.toggleMenu(self.viewModel.model.menuState, _completion: nil)
    }
}

class HomeViewController: BaseViewController, CoordinatorContext {
    
    weak var coordinator: HomeCoordinator?
    weak var delegate: HomeViewControllerDelegate?
    weak var delegate2: HomeViewControllerDelegate?
    
    private let tabBarView = TabBarView()
    private let viewModel: HomeViewModel
    
    var navigationViewController: UINavigationController?
    
    private let menuViewController = MenuViewController.instance()
    private let chattingViewController = ChattingViewController()
    
    private let communityId: Int?
    private let channelId: Int?
    
    init(communityId: Int?, channelId: Int?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.viewModel = HomeViewModel(
            chatWebSocketService: appDelegate?.coordinator?.chatWebSocketService as! ChatWebSocketService)
        
        self.communityId = communityId
        self.channelId = channelId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(communityId: Int?, channelId: Int?) -> HomeViewController {
        return HomeViewController(communityId: communityId, channelId: channelId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(tabBarView)
        
        self.tabBarView.setItem(tag: .home)
        
        tabBarView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
             
            $0.height.equalTo(80)
        }
        
        if (channelId != nil) {
            if (communityId != 0) {
                self.swipe("잡담", destinationStatus: .community((communityId!, channelId!, false)))
            } else {
                self.swipe("잡담", destinationStatus: .direct(channelId!))
            }
            
            // community, channel id,
//            self.delegate?.loadChatting("이름이 머야", channelId: channelId!, communityId: communityId!, isWebRTC: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVCs()
        self.viewModel.input.viewDidLoad.onNext(())
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
    
    // TODO: - 확인하기
    override func bindViewModel() {
        self.viewModel.output.menuState
            .asDriver(onErrorJustReturn: .opened)
            .drive(onNext: { menuState in
                self.toggleMenu(menuState, _completion: nil)
            }).disposed(by: disposeBag)
    }
    
    func toggleMenu(_ menuState: MenuState, _completion: (() -> Void)?) {
        switch menuState {
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut){
                self.navigationViewController?.view.frame.origin.x = self.chattingViewController.view.frame.size
                    .width-50
            } completion: { [weak self] done in
                if done {
                    self?.tabBarView.isHidden = false
                    self?.chattingViewController.messageInputBar.isHidden = true
                    
                    self?.self.viewModel.model.menuState = .closed
                }
            }
            
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut){
                self.navigationViewController?.view.frame.origin.x = 0
            } completion: { [weak self] done in
                if done {
                    self?.tabBarView.isHidden = true
                    self?.chattingViewController.messageInputBar.isHidden = false
                    
                    self?.viewModel.model.menuState = .opened
                }
            }
        }
    }
}

// TODO: - RxStream으로 리팩토링 필요
// MARK: - Data 동기화 (menu < - home - > chatting)
extension HomeViewController: MenuViewControllerDelegate {
    func swipe(_ chatName: String, destinationStatus: DestinationStatus) {
        
        switch (destinationStatus) {
        case .home, .direct:
            self.viewModel.chatWebSocketService.unsubscribe(nil)
        case .community((let communityId, _, _)): // community, channel id
            self.viewModel.chatWebSocketService.unsubscribe(communityId)
        }
        
        self.viewModel.chatWebSocketService.joinChannel(destinationStatus)
        
        switch destinationStatus {
        case .home:
            if (self.channelId != nil) {
                self.didTapMenuButton(channelId: channelId!, communityId: nil, isWebRTC: false)
            }
        case .direct(let channelId):
            self.didTapMenuButton(channelId: channelId, communityId: nil, isWebRTC: false) // 화면전환
            self.delegate?.loadChatting(chatName, channelId: channelId, communityId: nil, isWebRTC: false)
        case .community( (let communityId, let channelId, let isWebRTC) ):
            self.didTapMenuButton(channelId: channelId, communityId: communityId, isWebRTC: isWebRTC) // 화면전환
            self.delegate?.loadChatting(chatName, channelId: channelId, communityId: communityId, isWebRTC: isWebRTC)
            
            if (isWebRTC) {
                self.tabBarView.isHidden = true
                self.chattingViewController.messageInputBar.isHidden = true
            }
        }
        
    }
}
