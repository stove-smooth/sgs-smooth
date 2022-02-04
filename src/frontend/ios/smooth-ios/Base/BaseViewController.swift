//
//  BaseViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift
import Toast_Swift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindEvent()
    }
    
    func bindViewModel() {}
    func bindEvent() { }
    
    func showToast(message: String, isWarning: Bool) {
        var style = ToastStyle()
        style.backgroundColor = .serverListDarkGray!
        style.cornerRadius = 15
        
        let emoji = isWarning ? "⛔️ " : "✅ "
        
        self.view.makeToast(
            emoji+message,
            position: .top,
            style: style
        )
    }
}
