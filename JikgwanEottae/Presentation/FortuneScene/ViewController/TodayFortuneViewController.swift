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
    private let viewModel: TodayFortuneViewModel
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = todayFortuneView
    }
    
    init(viewModel: TodayFortuneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupPickerView()
        setupDatePicker()
        setupToolBar()
        bindUnderlineColorToEditingState()
        bindViewModel()
    }
    
    /// 피커 뷰를 설정합니다.
    private func setupPickerView() {
        // 선택된 시간 아이템을 텍스트 필드와 바인드합니다.
        todayFortuneView.timePickerView.rx.modelSelected(String.self)
            .compactMap { $0.first }
            .bind(to: todayFortuneView.timeInputField.textField.rx.text)
            .disposed(by: disposeBag)
        
        // 선택된 성별 아이템을 텍스트 필드와 바인드합니다.
        todayFortuneView.genderPickerView.rx.modelSelected(String.self)
            .compactMap { $0.first }
            .bind(to: todayFortuneView.genderInputField.textField.rx.text)
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
    
    /// 언더라인을 편집 상태와 바인드하여 색상을 업데이트합니다.
    private func bindUnderlineColorToEditingState() {
        let textFields = [
            todayFortuneView.birthInputField.textField,
            todayFortuneView.timeInputField.textField,
            todayFortuneView.genderInputField.textField,
            todayFortuneView.kboTeamInputField.textField
        ]
        let inputFields = [
            todayFortuneView.birthInputField,
            todayFortuneView.timeInputField,
            todayFortuneView.genderInputField,
            todayFortuneView.kboTeamInputField
        ]
        for (index, textField) in textFields.enumerated() {
            let inputField = inputFields[index]
            textField.rx.controlEvent(.editingDidBegin)
                .subscribe(onNext: {
                    UIView.animate(withDuration: 0.25) {
                        inputField.setUnderlineColor(.mainCharcoalColor)
                    }
                })
                .disposed(by: disposeBag)
            textField.rx.controlEvent(.editingDidEnd)
                .subscribe(onNext: {
                    UIView.animate(withDuration: 0.25) {
                        inputField.setUnderlineColor(.primaryBackgroundColor)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func bindViewModel() {
        let input = TodayFortuneViewModel.Input(
            dateOfBirth: todayFortuneView.birthInputField.textField.rx.text.orEmpty.asObservable(),
            timeOfBirth: todayFortuneView.timeInputField.textField.rx.text.orEmpty.asObservable(),
            gender: todayFortuneView.genderInputField.textField.rx.text.orEmpty.asObservable(),
            favoriteKBOTeam: todayFortuneView.kboTeamInputField.textField.rx.text.orEmpty.asObservable(),
            completeButtonTapped: todayFortuneView.completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        // 태어난 시각 피커에 아이템을 전달합니다.
        output.timePickerItems
            .drive(todayFortuneView.timePickerView.rx.itemTitles) { _, item in
                return "\(item)시"
            }
            .disposed(by: disposeBag)
        
        // 성별 피커에 아이템을 전달합니다.
        output.genderPickerItems
            .drive(todayFortuneView.genderPickerView.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)
        
        // 구단 피커에 아이템을 전달합니다.
        output.kboTeamPickerItems
            .drive(todayFortuneView.kboTeamPickerView.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)
        
        // 오늘의 직관 운세 데이터를 전달합니다.
        output.fortune
            .withUnretained(self)
            .subscribe(onNext: { owner, fortune in
                owner.showTodayFortuneResult(with: fortune)
            })
            .disposed(by: disposeBag)
        
        // 필수 입력란 누락 에러를 전달합니다.
        output.error
            .withUnretained(self)
            .bind(onNext: { owner, _ in
                owner.showRequiredInputAlert()
            })
            .disposed(by: disposeBag)
        
        // 로딩 상태를 전달합니다.
        output.isLoading
            .emit(to: todayFortuneView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}


extension TodayFortuneViewController {
    /// 툴바의 Done 버튼이 클릭됬을 때 툴바를 닫습니다.
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
}

extension TodayFortuneViewController {
    /// 오늘의 직관 운세 결과 화면으로 이동합니다.
    private func showTodayFortuneResult(with fortune: Fortune) {
        let todayFortuneResultViewController = TodayFortuneResultViewController(fortune: fortune)
        todayFortuneResultViewController.modalPresentationStyle = .overFullScreen
        self.present(todayFortuneResultViewController, animated: true) {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    /// 필수 입력란이 누락됬을 경우 안내 팝업을 표시합니다.
    private func showRequiredInputAlert() {
        self.showAlert(title: "안내", message: "필수 정보를 모두 입력해주세요", doneTitle: "확인")
    }
}
