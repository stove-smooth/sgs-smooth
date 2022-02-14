//
//  ProfileViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/14.
//

import UIKit

class ProfileViewController: BaseViewController {
    private let profileView = ProfileView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> ProfileViewController {
        return ProfileViewController()
    }
    
    override func bindViewModel() {
        
    }
}

/**
import SafariServices

class ProfileViewController: BaseViewController, SFSafariViewControllerDelegate {
    
    private let profileView = ProfileView()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> ProfileViewController {
        return ProfileViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view = self.profileView
//        self.loadURL()
        
        guard let url = URL(string: "https://yoloyolo.org/m/channels/0/20?userId=3&accessToken=123") else {
            return
        }
        
        let safariView = SFSafariViewController(url: url)
        safariView.delegate = self
        safariView.modalPresentationStyle = .automatic
        self.present(safariView, animated:  true, completion:  nil )
        
    }
    // https://yoloyolo.org/m/channels/0/20?userId=3&accessToken=123
    private func loadURL() {
        guard let url = URL(string: "https://yoloyolo.org/m/channels/0/20?userId=3&accessToken=123") else {
            return
        }
        
//        let request = URLRequest(url: url!)
        
//        self.profileView.webView.allowsBackForwardNavigationGestures = true
//        self.profileView.webView.load(request)
    }
}

//void WKPreferencesSetMediaDevicesEnabled(WKPreferences* preferencesRef, bool enabled)
 */
