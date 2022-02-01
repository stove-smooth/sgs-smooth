//
//  ChannelCategoryCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit
import RxSwift

class ChannelCategoryCell: UITableViewHeaderFooterView {
    static let identifier = "\(ChannelCategoryCell.self)"
    
    let diposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
    }
    
    let addButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
        bindConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup() {
        self.backgroundColor = .clear
        [titleLabel, addButton].forEach {self.addSubview($0)}
    }
    
    func bindConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-15)
            $0.height.width.equalTo(20)
        }
    }
    
}
