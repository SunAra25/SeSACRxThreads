//
//  KeywordCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 아라 on 8/7/24.
//

import UIKit

class KeywordCollectionViewCell: UICollectionViewCell {
    static let identifier = "KeywordCollectionViewCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(label)
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(8)
        }
    }
}
