//
//  ServerCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/09.
//

import UIKit
import Then
import SnapKit

class ServerCell: UITableViewCell {
    static var identifier: String { return "\(self)" }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        ui()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ui() {
        self.backgroundColor = .clear
        self.contentView.frame = contentView.frame.inset(by: UIEdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0))
    }
}
