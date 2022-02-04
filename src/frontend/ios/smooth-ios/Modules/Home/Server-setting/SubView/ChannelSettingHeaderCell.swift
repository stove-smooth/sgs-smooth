//
//  ChannelSettingHeaderCEll.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit

class ChannelSettingHeaderCell: UITableViewHeaderFooterView {
    
    static let identifier = "\(ChannelSettingHeaderCell.self)"
    
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
    }
    
    let editButton = UIButton().then {
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.textColor = .iconDefault
        $0.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
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
        [titleLabel, editButton].forEach {self.addSubview($0)}
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
        }
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
}

