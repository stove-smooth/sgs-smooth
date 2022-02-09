//
//  ChannelCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/09.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ChannelCell: BaseTableViewCell {
    static let identifier = "\(ChannelCell.self)"
    
    override func setup() {
        self.backgroundColor = .clear
        self.textLabel?.textColor = .white
        self.tintColor = .white
        self.clipsToBounds = true
        self.selectionStyle = .none
    }
    
    func bind(channel: Channel) {
        self.textLabel?.text = "\(channel.name)"
        self.imageView?.image = UIImage(named: "Channel+\(channel.type.rawValue.lowercased())")?.resizeImage(size: CGSize(width: 20, height: 20))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.textLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .bold)
            self.backgroundColor = UIColor(hex: "0x3A3C41")
            self.layer.cornerRadius = 5
            self.textLabel?.textColor = .white
        } else {
            self.textLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .regular)
            self.backgroundColor = .clear
            self.layer.cornerRadius = 0
            self.textLabel?.textColor = .iconDefault
        }
    }
}
