//
//  CategoryReorderCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/02/01.
//

import UIKit

class CategoryReorderCell: BaseTableViewCell {
    
    static let identifier = "\(CategoryReorderCell.self)"
    
    let titleLabel = UILabel().then {
        $0.textColor = .iconDefault
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
    }
    
    let rightButton = UIImageView().then {
        $0.image = UIImage(systemName: "line.3.horizontal")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal)
    }

    override func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        [titleLabel, rightButton].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().offset(-24)
        }
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
}
