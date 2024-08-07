//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by 아라 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    let list = BehaviorRelay<[Shopping]>(value: [])
    let keywordList = BehaviorRelay<[String]>(value: [])
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let addBtnTap: Observable<String>
        let checkBtnTap: Observable<Int>
        let starBtnTap: Observable<Int>
        let keywordBtnTap: Observable<String>
    }
    
    struct Output {
        let updateList: BehaviorRelay<[Shopping]>
    }
    
    func transform(input: Input) -> Output {
        input.addBtnTap
            .bind(with: self) { owner, value in
                var newList = owner.keywordList.value
                newList.append(value)
                owner.keywordList.accept(newList)
            }.disposed(by: disposeBag)
        
        input.checkBtnTap
            .bind(with: self) { owner, index in
                var newList = owner.list.value
                newList[index].isComplete.toggle()
                owner.list.accept(newList)
            }.disposed(by: disposeBag)
        
        input.starBtnTap
            .bind(with: self) { owner, index in
                var newList = owner.list.value
                newList[index].isLike.toggle()
                owner.list.accept(newList)
            }.disposed(by: disposeBag)
        
        input.keywordBtnTap
            .bind(with: self) { owner, value in
                var newList = owner.list.value
                let newValue = Shopping(isComplete: false, title: value, isLike: false)
                newList.append(newValue)
                owner.list.accept(newList)
            }.disposed(by: disposeBag)
        
        return Output(updateList: list)
    }
}
