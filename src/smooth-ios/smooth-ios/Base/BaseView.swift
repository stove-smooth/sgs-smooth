//
//  BaseView.swift
//  smooth-ios
//
//  Created by 김두리 on 2021/12/27.
//

import UIKit
import RxCocoa
import RxSwift


class BaseView: UIView {
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      setup()
      bindConstraints()
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
      setup()
      bindConstraints()
    }
    
    func setup() {}
    func bindConstraints() {}
    

}
