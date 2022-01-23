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
    
    private lazy var dimView = UIView(frame: self.frame).then {
        $0.backgroundColor = .clear
    }
    
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
    
    func showLoading(isShow: Bool) {
        print("todos showLoading")
    }
    
    func showDim(isShow: Bool) {
        if isShow {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.addSubview(self.dimView)
                UIView.animate(withDuration: 0.3) {
                    self.dimView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3, animations: {
                    self.dimView.backgroundColor = .clear
                }) { (_) in
                    self.dimView.removeFromSuperview()
                }
            }
        }
    }

}
