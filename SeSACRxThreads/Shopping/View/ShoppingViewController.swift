//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by 아라 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct Shopping {
    var isComplete: Bool
    let title: String
    var isLike: Bool
}

final class ShoppingViewController: UIViewController {
    private let inputTextField = {
        let tf = UITextField()
        tf.placeholder = "무엇을 구매하실건가요?"
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 0))
        tf.rightViewMode = .always
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
        view.rowHeight = 52
        return view
    }()
    private let collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        layout.estimatedItemSize = CGSize(width: 80, height: 40)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(KeywordCollectionViewCell.self, forCellWithReuseIdentifier: KeywordCollectionViewCell.identifier)
        return view
    }()
    
    let viewModel = ShoppingViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        configureView()
        bind()
    }
    
    func bind() {
        let addBtnTap = addButton.rx.tap
            .withLatestFrom(inputTextField.rx.text.orEmpty)
        let checkBtnTap = BehaviorRelay(value: 0)
        let starBtnTap = BehaviorRelay(value: 0)
        let keywordBtnTap = collectionView.rx.modelSelected(String.self)
        let input = ShoppingViewModel
            .Input(addBtnTap: addBtnTap.asObservable(),
                   checkBtnTap: checkBtnTap.asObservable().skip(1),
                   starBtnTap: starBtnTap.asObservable().skip(1),
                   keywordBtnTap: keywordBtnTap.asObservable())
        let output = viewModel.transform(input: input)
        
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { (row, element, cell) in
                cell.configureCell(element)
                
                cell.checkButton.rx.tap
                    .map { row }
                    .bind(to: checkBtnTap)
                    .disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .map { row }
                    .bind(to: starBtnTap)
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        viewModel.keywordList
            .bind(to: collectionView.rx.items(cellIdentifier: KeywordCollectionViewCell.identifier, cellType: KeywordCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = element
            }.disposed(by: disposeBag)
        
        output.resetInputText
            .bind(with: self) { owner, _ in
                owner.inputTextField.text = ""
            }.disposed(by: disposeBag)
    }
    
    func configureNavigation() {
        navigationItem.title = "쇼핑"
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(inputTextField)
        view.addSubview(addButton)
        view.addSubview(collectionView)
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}
