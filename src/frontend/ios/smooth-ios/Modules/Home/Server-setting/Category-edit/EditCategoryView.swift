//
//  EditCategoryView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit


class EditCategoryView: BaseView {
    let navigationView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
    }
    
    let closeButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
    }
    
    let naviTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "카테고리 설정"
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.tintColor = .white
        $0.isHidden = true
    }

    let categoryNameLabel = UILabel().then {
        $0.textColor = .iconDefault
        $0.text = "카테고리 이름"
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
    }
    
    let categoryNameInput = InputTextField().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.textColor = .white
        $0.tintColor = .white
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let deleteButton = UIButton().then {
        $0.setTitle("카테고리 삭제", for: .normal)
        $0.setTitleColor(.red, for: .normal)
        $0.backgroundColor = .backgroundDarkGray
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    override func setup() {
        self.backgroundColor = UIColor.messageBarDarkGray
        
        [closeButton, naviTitleLabel, saveButton].forEach { navigationView.addSubview($0) }
        [
            navigationView, categoryNameLabel, categoryNameInput, deleteButton
        ].forEach {self.addSubview($0)}
    }
    
    override func bindConstraints() {
        navigationView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview()
        }
        
        naviTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(closeButton)
        }
        
        saveButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
        
        categoryNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(navigationView.snp.bottom).offset(20)
        }
        
        categoryNameInput.snp.makeConstraints {
            $0.top.equalTo(categoryNameLabel.snp.bottom).offset(5)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(categoryNameInput.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    func bind(name: String) {
        categoryNameInput.text = name
    }
}
