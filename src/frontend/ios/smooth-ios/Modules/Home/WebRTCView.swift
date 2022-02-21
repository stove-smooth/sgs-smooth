//
//  WebRTCView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/18.
//

import UIKit
import WebKit

class WebRTCView: BaseView {

    let backButton = UIButton().then {
      $0.setImage(UIImage(named: "ic_back_white"), for: .normal)
    }

    let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()

    override func setup() {
        [ webView ].forEach { self.addSubview($0) }
    }

    override func bindConstraints() {
        self.webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


