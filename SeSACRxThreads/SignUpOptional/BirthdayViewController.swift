//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    lazy var selectedComponents = BehaviorRelay<DateComponents>(value: todayComponents)
    
    let disposeBag = DisposeBag()
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = .systemRed
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        let isValid = selectedComponents
            .map { [weak self] selected in
                guard let self else { return false}
                guard let selectedYear = selected.year,
                      let currentYear = todayComponents.year else { return false }
                guard let selectedMonth = selected.month,
                      let currentMonth = todayComponents.month else { return false }
                guard let selectedDay = selected.day,
                      let currentDay = todayComponents.day else { return false }
                
                if currentMonth > selectedMonth || (currentMonth == selectedMonth && currentDay >= selectedDay) {
                    return currentYear - selectedYear >= 17
                } else {
                    return currentYear - selectedYear - 1 >= 17
                }
            }
        
        isValid.bind(with: self) { owner, isValid in
            owner.infoLabel.text = isValid ? "가입 가능한 나이입니다" : "만 17세 이상만 가입 가능합니다."
            owner.infoLabel.textColor = isValid ? .systemBlue : .systemRed
            owner.nextButton.backgroundColor = isValid ? .systemBlue : .lightGray
            owner.nextButton.isEnabled = isValid
        }.disposed(by: disposeBag)
        
        selectedComponents.bind(with: self) { owner, value in
            guard let year = value.year,
                    let month = value.month,
                    let day = value.day else { return }
            
            owner.yearLabel.text = "\(year)년"
            owner.monthLabel.text = "\(month)월"
            owner.dayLabel.text = "\(day)일"
        }.disposed(by: disposeBag)
        
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                owner.selectedComponents.accept(component)
            }.disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert()
            }.disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    func showAlert() {
        let alert = UIAlertController(title: "완료", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
