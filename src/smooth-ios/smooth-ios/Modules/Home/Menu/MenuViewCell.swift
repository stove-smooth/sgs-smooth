//
//  MenuViewCell.swift
//  smooth-ios
//
//  Created by 김하나 on 2022/01/08.
//

import UIKit
import Then
import RxSwift
import RxCocoa


//class MenuviewCell: UICollectionViewCell {
//    static var identifier: String { return "\(self)" }
//    
//    var disposeBag = DisposeBag()
//    
//    let serverButton = UIButton().then {
//        $0.layer.cornerRadius = $0.bounds.size.width * 0.5
//    }
//    
//    let serverButton2 = UIButton().then {
//        $0.layer.cornerRadius = $0.bounds.size.width * 0.5
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setLayout() {
//        self.layer.borderWidth = 1
//        
//        let stackView = UIStackView(arrangedSubviews: [
//            serverButton,
//            serverButton2
//        ])
//        
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.spacing = 10
//        
//        contentView.addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.edges.equalTo(self.snp.margins)
//        }
//    }
//    
//    func configure(with factory: @escaping (CellInput) -> CellViewModel) {
//        let input = CellInput(server: serverButton.rx.tap.asObservable())
//        
//        let viewModel = factory(input)
//        
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        disposeBag = DisposeBag()
//    }
//}
