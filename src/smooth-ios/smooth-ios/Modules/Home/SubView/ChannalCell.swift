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

class ChannelCell: UITableViewCell {
    static let identifier = "ChannelCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.backgroundColor = .clear
        self.textLabel?.textColor = .white
//        self.selectionStyle = .none
        
        self.tintColor = .white
        self.clipsToBounds = true
    }
    
    func bind(channel: Channel) {
        self.textLabel?.text = "\(channel.name)"
        self.imageView?.image = UIImage(named: "Channel+\(channel.type)")?.resizeImage(size: CGSize(width: 20, height: 20))
    }
}
