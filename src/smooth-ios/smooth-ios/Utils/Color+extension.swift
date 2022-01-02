//
//  Color+extension.swift
//  smooth-ios
//
//  Created by durikim-MN on 2021/12/29.
//

import Foundation
import UIKit

extension UIColor {
    static let blurple = UIColor(hex: "0x5865f2")
    static let lightBlurple = UIColor(hex: "0x949cf7")
    static let blurple_oc = UIColor(hex: "7389da")
    
    static let red = UIColor(hex: "0xed42445")
    static let green = UIColor(hex: "0x58f287")
    static let yellow = UIColor(hex: "0xf7de52")
    static let white = UIColor(hex: "0xffffff")
    static let streaming = UIColor(hex: "0x593695")
    
    static let greyple = UIColor(hex: "0x99aab5")
    static let online = UIColor(hex: "0x51b581")
    static let offline = UIColor(hex: "0x747f8d")
    
    static let iconsLightGrey = UIColor(hex: "0xc0bcbc")
    static let iconsDarkGrey = UIColor(hex: "0x4f5660")
    static let toolTip_UserProfile = UIColor(hex: "0x18191c")
    
    static let messageBarDarkGrey = UIColor(hex: "0x40444b")
    static let messageBarLightGrey = UIColor(hex: "0xf0ecf4")
    
    static let textChannelDartGrey = UIColor(hex: "0x36393f")
    
    static let channelListDartGrey = UIColor(hex: "0x2f3136")
    static let channelListLightGrey = UIColor(hex: "0xf8f4f4")
    
    
    static let serverListDartGrey = UIColor(hex: "0x202225")
    static let serverListLightGrey = UIColor(hex: "0xe8e4ec")
    
}


extension UIColor {
    convenience init?(hex: String, alpha: Double=1){
        var string = ""
        if hex.lowercased().hasPrefix("0x") {
            string = hex.replacingOccurrences(of: "0x", with: "")
        } else if hex.hasPrefix("#") {
            string = hex.replacingOccurrences(of: "#", with: "")
        } else {
            string = hex
        }
        
        if string.count == 3 {
            var str = ""
            string.forEach {
                str.append(String(repeating: String($0), count: 2))
            }
            string = str
        }
        
        guard let hexValue = Int(string, radix: 16) else { return nil }
        
        var a = alpha
        if a < 0 { a = 0 }
        if a > 1 { a = 1 }
        
        let red = CGFloat((hexValue >> 16) & 0xff) / 255
        let green = CGFloat((hexValue >> 8) & 0xff) / 255
        let blue = CGFloat(hexValue & 0xff) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(a))
    }
}
