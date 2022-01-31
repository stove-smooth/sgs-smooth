//
//  MakeCategoryView.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/31.
//

import UIKit

class MakeCategoryView: BaseView {
    let navigationView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
    }
    
    let closeButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
    }
    
    let naviTitleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "카테고리 만들기"
        $0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize-1, weight: .bold)
    }
    
    let makeButton = UIButton().then {
        $0.setTitle("만들기", for: .normal)
        $0.tintColor = .white
    }

    let categoryNameLabel = UILabel().then {
        $0.textColor = .iconDefault
        $0.text = "카테고리 이름"
    }
    
    let categoryNameInput = InputTextField().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.textColor = .white
        $0.tintColor = .white
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let accessView = UIView().then {
        $0.backgroundColor = .backgroundDarkGray
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.serverListDarkGray?.cgColor
    }
    
    let accessIcon = UIImageView().then {
        $0.image = UIImage(systemName: "lock.fill")?.withTintColor(.iconDefault!, renderingMode: .alwaysOriginal)
    }
    
    let accessLabel = UILabel().then {
        $0.text = "비공개 카테고리"
        $0.textColor = .white
    }
    
    let accessButton = UISwitch().then {
        $0.onTintColor = .lightBlurple
        $0.isOn = false
    }
    
    let accessDescription = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "카테고리를 비공개로 만들면 선택한 멤버들과 역할만 이 카테고리를 볼 수 있어요. 이 설정은 이 카테고리에 동기화된 채널들에도 자동으로 적용돼요."
        $0.textAlignment = .justified
        $0.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .light)
        $0.textColor = .iconDefault
    }
    
    override func setup() {
        self.backgroundColor = UIColor.messageBarDarkGray
        
        [closeButton, naviTitleLabel, makeButton].forEach { navigationView.addSubview($0) }
        
        [
            accessIcon, accessLabel, accessButton
        ].forEach { accessView.addSubview($0) }
        
        [
            navigationView,
            categoryNameLabel, categoryNameInput,
            accessView, accessDescription
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
        
        makeButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview()
        }
        
        categoryNameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(navigationView.snp.bottom).offset(20)
        }
        
        categoryNameInput.snp.makeConstraints {
            $0.top.equalTo(categoryNameLabel.snp.bottom).offset(3)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview()
        }
        
        accessView.snp.makeConstraints {
            $0.top.equalTo(categoryNameInput.snp.bottom).offset(15)
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview()
        }
        
        accessIcon.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        accessLabel.snp.makeConstraints {
            $0.left.equalTo(accessIcon.snp.right).offset(5)
            $0.centerY.equalToSuperview()
        }
        
        accessButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
        
        accessDescription.snp.makeConstraints {
            $0.top.equalTo(accessView.snp.bottom).offset(5)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
    }
}
