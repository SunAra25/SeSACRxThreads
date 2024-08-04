//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 아라 on 8/4/24.
//

import UIKit
import SnapKit

final class ShoppingTableViewCell: UITableViewCell {
    static let identifier = "ShoppingTableViewCell"
    
    let checkButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "checkmark.square")
        button.configuration = config
        return button
    }()
    let contentLabel = {
        let label = UILabel()
        return label
    }()
    let starButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "star")
        button.configuration = config
        return button
    }()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalTo(checkButton.snp.trailing).offset(20)
        }
        
        starButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(32)
        }
    }
}


