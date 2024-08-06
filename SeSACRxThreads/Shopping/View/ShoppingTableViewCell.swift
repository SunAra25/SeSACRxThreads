//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 아라 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift

final class ShoppingTableViewCell: UITableViewCell {
    static let identifier = "ShoppingTableViewCell"
    
    let checkButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "checkmark.square")
        button.configuration = config
        button.tintColor = .black
        return button
    }()
    let contentLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    let starButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "star")
        button.configuration = config
        button.tintColor = .black
        return button
    }()
    
    var disposeBag = DisposeBag()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configure() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .systemGray6
        contentView.clipsToBounds = true
        
        contentView.addSubview(checkButton)
        contentView.addSubview(contentLabel)
        contentView.addSubview(starButton)
        
        checkButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(12)
        }
        
        starButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
            make.width.equalTo(40)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalTo(checkButton.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(starButton.snp.leading)
        }
    }
    
    func configureCell(_ value: Shopping) {
        checkButton.configuration?.image = value.isComplete ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        
        starButton.configuration?.image = value.isLike ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        contentLabel.text = value.title
        contentLabel.preferredMaxLayoutWidth = contentLabel.frame.width
        contentView.layoutIfNeeded()
    }
}


