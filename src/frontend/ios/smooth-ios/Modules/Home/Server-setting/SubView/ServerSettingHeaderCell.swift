//
//  ServerSettingHeaderCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/30.
//

import UIKit

class ServerSettingHeaderCell: UITableViewHeaderFooterView {
    
    static let identifier = "\(ServerSettingCell.self)"
    
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup() {
        self.backgroundColor = .clear
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
}
