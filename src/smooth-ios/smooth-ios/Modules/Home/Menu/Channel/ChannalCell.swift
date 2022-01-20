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
    static var identifier: String { return "\(self)" }
    
    //    let nameLabel: UILabel
    //    let idLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ui() {
        self.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 2
        self.layoutMargins = UIEdgeInsets.symmetric(vertical: 8, horizontal: 12)
    }
    
}

//class ChannelCell: UICollectionViewCell {
//    static var identifier: String { return "\(self)" }
//
//    var disposeBag = DisposeBag()
//
//    let label = UILabel()
//    let check = UIButton().then {$0.setTitle("check", for: .normal)}
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        ui()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func ui() {
//        self.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
//        self.layer.borderWidth = 1
//        self.layer.cornerRadius = 2
//        self.layoutMargins = UIEdgeInsets.symmetric(vertical: 8, horizontal: 12)
//        let stackButtons = UIStackView(arrangedSubviews: [
//            check
//            ])
//        stackButtons.axis = .horizontal
//        stackButtons.alignment = .center
//        stackButtons.distribution = .fill
//        stackButtons.spacing = 8
//
//        let stackView = UIStackView(arrangedSubviews: [
//            label,
//            stackButtons
//            ])
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.distribution = .fill
//        stackView.spacing = 8
//        contentView.addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.edges.equalTo(self.snp.margins)
//        }
//    }
//
//    func configure(with factory: @escaping (CellInput) -> CellViewModel) {
//        // create the input object
//        let input = CellInput(
//            select: check.rx.tap.asObservable()
//        )
//
//        // create the view model from the factory
//        let viewModel = factory(input)
//        // bind the view model's label property to the label
//
//        viewModel.selected
//            .bind(to: check.rx.isSelected)
//            .disposed(by: disposeBag)
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        disposeBag = DisposeBag()
//    }
//}
