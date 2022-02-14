//
//  ServerButtonCell.swift
//  smooth-ios
//
//  Created by 김두리 on 2022/01/25.
//

import Foundation
import UIKit

class ServerButtonCell: BaseTableViewCell {
    static let identifier = "\(ServerButtonCell.self)"
    var type: ServerCellType?
    
    let iconView = UIView().then {
        $0.backgroundColor = .messageBarDarkGray
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    let iconImge = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let selectedView = UIView().then {
        $0.layer.contents = 20
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImge.image = nil
        selectedView.isHidden = true
    }
    
    override func setup() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        [
            iconView, iconImge, selectedView
        ].forEach {self.contentView.addSubview($0)}
    }
    
    override func bindConstraints() {
        iconView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        iconImge.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        selectedView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.height.equalTo(60)
            $0.width.equalTo(5)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            // 원형 -> 둥근 사각형으로
            selectedView.isHidden = false
            
            switch self.type {
            case .home: iconView.backgroundColor = .blurple
            case .add:
                iconView.backgroundColor = .online
                iconImge.image = UIImage(systemName: "plus")?.withTintColor(.white!, renderingMode: .alwaysOriginal)
            case .none, .normal, .direct: break
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)}, completion: { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.transform = .identity
                    }
                })
            UIView.animate(withDuration: 0.3, delay: 0,  animations: {
                self.iconView.layer.cornerRadius = 10.0
            }, completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            })
        } else {
            selectedView.isHidden = true
            iconView.backgroundColor = .messageBarDarkGray
            
            switch self.type {
            case .add:
                iconImge.image = UIImage(systemName: "plus")?.withTintColor(.online!, renderingMode: .alwaysOriginal)
            case .none, .normal, .home, .direct: break
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)}, completion: { finished in
                    UIView.animate(withDuration: 0.2) {
                        self.transform = .identity
                    }
                })
            UIView.animate(withDuration: 0.3, delay: 0,  animations: {
                self.iconView.layer.cornerRadius = 30
            }, completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            })
        }
    }
    
    func bind(type: ServerCellType) {
        self.type = type
        
        switch type {
        case .normal, .direct: break
        case .home:
            iconImge.image = UIImage(named: "Logo")
        case .add:
            iconImge.image = UIImage(systemName: "plus")?.withTintColor(.online!, renderingMode: .alwaysOriginal)
        }
    }
}
