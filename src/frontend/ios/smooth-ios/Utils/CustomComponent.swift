//
//  CustomComponent.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import UIKit
import Then

extension UIEdgeInsets {
    static func all(_ value: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }
    static func symmetric(vertical: CGFloat, horizontal: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

class InputTextField: UITextField {
    private let commonInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    private let clearButtonOffset: CGFloat = 5
    private let clearButtonLeftPadding: CGFloat = 5

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: commonInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        _ = clearButtonRect(forBounds: bounds).width
        let editingInsets = UIEdgeInsets(
            top: commonInsets.top,
            left: commonInsets.left,
            bottom: commonInsets.bottom,
            right: commonInsets.right
        )
        
        return bounds.inset(by: editingInsets)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var clearButtonRect = super.clearButtonRect(forBounds: bounds)
        clearButtonRect.origin.x -= clearButtonOffset;
        
        return clearButtonRect
    }
    
}
