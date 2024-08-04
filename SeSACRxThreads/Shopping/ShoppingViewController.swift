//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by 아라 on 8/4/24.
//

import UIKit
import SnapKit

final class ShoppingViewController: UIViewController {
    private let inputTextField = {
        let tf = UITextField()
        tf.placeholder = "무엇을 구매하실건가요?"
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 12
        return tf
    }()
    private let addButton = {
        let button = UIButton()
        var attr = AttributedString.init("추가")
        attr.font = UIFont.systemFont(ofSize: 16)
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attr
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .systemGray5
        button.configuration = config
        return button
    }()
    private let tableView = {
        let view = UITableView()
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        view.rowHeight = 44
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureView()
    }
    
    func configureNavigation() {
        navigationItem.title = "쇼핑"
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(inputTextField)
        view.addSubview(addButton)
        view.addSubview(tableView)
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(60)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(inputTextField)
            make.trailing.equalTo(inputTextField.snp.trailing).inset(16)
            make.height.equalTo(32)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

}
