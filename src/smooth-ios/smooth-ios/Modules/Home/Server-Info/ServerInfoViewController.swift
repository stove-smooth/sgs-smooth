//
//  ServerInfoViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/28.
//

import Foundation
import PanModal

class ServerInfoViewController: BaseViewController, PanModalPresentable {
    var panScrollable: UIScrollView?
    
    weak var coordinator: HomeCoordinator?
    
    private lazy var serverInfoView = ServerInfoView(frame: self.view.frame)
    private let viewModel: ServerInfoViewModel
    
    let communityInfo: CommunityInfo
    
    init(communityInfo: CommunityInfo) {
        self.communityInfo = communityInfo
        self.viewModel = ServerInfoViewModel(
            communityInfo: communityInfo,
            serverRepository: ServerRepository()
        )
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance(communityInfo: CommunityInfo) -> ServerInfoViewController {
        return ServerInfoViewController(communityInfo: communityInfo).then {
            $0.modalPresentationStyle = .overCurrentContext
        }
    }
    
    var shortFormHeight: PanModalHeight {
        let half = view.bounds.height/2
        return .contentHeight(half)
    }
    
    var longFormHeight: PanModalHeight {
        let row = view.bounds.height/8
        return .contentHeight(row*7)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = serverInfoView
        serverInfoView.bind(communityInfo: self.communityInfo)
    }
    
    override func bindViewModel() {
        
    }
}
