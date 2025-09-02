//
//  TodayFortuneViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/2/25.
//

import UIKit

import RxSwift
import RxCocoa

final class TodayFortuneViewController: UIViewController {
    private let todayFortuneView = TodayFortuneView()
    private let timePickerData = Observable.just(Array(0...23).map{ String($0) })
    private let sexPickerData = Observable.just(["남성", "여성"])
    private let kboTeamPickerData = Observable.just(KBOTeam.allCases.map{ $0.rawValue })
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = todayFortuneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupPickerView()
        setupDatePicker()
        setupToolBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    /// 피커 뷰를 설정합니다.
    private func setupPickerView() {
        // 시각 아이템을 피커 뷰와 바인드합니다.
        timePickerData
            .bind(to: todayFortuneView.timePickerView.rx.itemTitles) { _, item in
                return "\(item)시"
            }
            .disposed(by: disposeBag)
        // 성별 아이템을 비커 뷰와 바인드합니다.
        sexPickerData
            .bind(to: todayFortuneView.sexPickerView.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)
        // KBO구단 아이템을 피커 뷰와 바인드합니다.
        kboTeamPickerData
            .bind(to: todayFortuneView.kboTeamPickerView.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)
        // 선택된 시간 아이템을 텍스트 필드와 바인드합니다.
        todayFortuneView.timePickerView.rx.modelSelected(String.self)
            .compactMap { $0.first }
            .bind(to: todayFortuneView.timeInputField.textField.rx.text)
            .disposed(by: disposeBag)
        // 선택된 성별 아이템을 텍스트 필드와 바인드합니다.
        todayFortuneView.sexPickerView.rx.modelSelected(String.self)
            .compactMap { $0.first }
            .bind(to: todayFortuneView.sexInputField.textField.rx.text)
            .disposed(by: disposeBag)
        // 선택된 KBO구단 아이템을 텍스트 필드와 바인드합니다.
        todayFortuneView.kboTeamPickerView.rx.modelSelected(String.self)
            .compactMap { $0.first }
            .bind(to: todayFortuneView.kboTeamInputField.textField.rx.text)
            .disposed(by: disposeBag)
    }
    /// 데이트 피커를 설정합니다.
    private func setupDatePicker() {
        todayFortuneView.datePicker.rx.date
            .skip(1)
            .map { $0.toFormattedString("yyyyMMdd") }
            .bind(to: todayFortuneView.birthInputField.textField.rx.text)
            .disposed(by: disposeBag)
    }
    /// 툴바를 설정합니다.
    private func setupToolBar() {
        todayFortuneView.setupToolBar(target: self, action: #selector(dismissPicker))
    }
    
    /// 툴바의 Done 버튼이 클릭됬을 때 툴바를 닫습니다.
    @objc private func dismissPicker() {
        view.endEditing(true)
    }

}
