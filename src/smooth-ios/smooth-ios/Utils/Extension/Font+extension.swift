//
//  Font+extension.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/04.
//

import UIKit

extension UIFont {
    class func GintoNord(type: GintoNordType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        
        return font
    }
    
    public enum GintoNordType {
        case Bold
        case Medium
        
        var name: String {
            switch self {
            case .Bold:
                return "ABCGintoNordTrial-Black"
            case .Medium:
                return "ABCGintoNordTrial-Medium"
            }
        }
    }
}
