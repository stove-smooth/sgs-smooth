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
    }
    
    func bind(channel: Channel) {
        self.textLabel?.text = "\(channel.name)"
        self.imageView?.image = UIImage(named: "Channel+\(channel.type)")?.resizeImage(size: CGSize(width: 20, height: 20))
    }
}
