//
//  BaseViewController.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    
    func bindViewModel() {}
}
