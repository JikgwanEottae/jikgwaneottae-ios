//
//  FortuneBirthInputViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/10/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 오늘의 직관 운세를 확인하기 위한 생년월일 입력 뷰 컨트롤러입니다.

final class FortuneBirthInputViewController: UIViewController {
    private let fortuneBirthInputView = FortuneBirthInputView()
    private let viewModel: FortuneBirthInputViewModel
    private let hours: [Int] = Array(0...23)
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = fortuneBirthInputView
    }
    
    init(viewModel: FortuneBirthInputViewModel) {
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
        setupDelegates()
        setupDataSources()
        bindDatePicker()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fortuneBirthInputView.progressView.setProgress(0.9, animated: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }
    
    private func setupDelegates() {
        fortuneBirthInputView.timePickerView.delegate = self
    }
    
    private func setupDataSources() {
        fortuneBirthInputView.timePickerView.dataSource = self
    }
    
    private func bindDatePicker() {
        fortuneBirthInputView.datePicker.rx.date
            .skip(1)
            .map { $0.toFormattedString("yyyyMMdd") }
            .withUnretained(self)
            .subscribe(onNext: { owner, birth in
                owner.fortuneBirthInputView.updateBirth(birth)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = FortuneBirthInputViewModel.Input(
            birth: fortuneBirthInputView.birthInputField.textField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            time: fortuneBirthInputView.timeInputField.textField.rx.text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            completeButtonTapped: fortuneBirthInputView.completeButton.rx.tap
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.fetchSuccess
            .withUnretained(self)
            .subscribe(onNext: { owner, fortune in
                owner.presentFortuneResultScene(fortune)
            })
            .disposed(by: disposeBag)
        
        output.fetchFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(
                    title: "알림",
                    message: "운세를 불러오지 못했어요",
                    doneTitle: "확인",
                    doneStyle: .cancel
                )
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(fortuneBirthInputView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.showEmptyAlert
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(
                    title: "알림",
                    message: "생년월일을 필수로 선택해주세요",
                    doneTitle: "닫기",
                    doneStyle: .cancel
                )
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UIPickerViewDataSource

extension FortuneBirthInputViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hours.count
    }
}

// MARK: - UIPickerViewDelegate

extension FortuneBirthInputViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(hours[row])시"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fortuneBirthInputView.updateTime("\(hours[row])시")
    }
}

// MARK: - Transition

extension FortuneBirthInputViewController {
    private func presentFortuneResultScene(_ fortune: Fortune) {
        let viewModel = FortuneResultViewModel(fortune: fortune)
        let viewController = FortuneResultViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true) { [weak self]  in
            self?.navigationController?.popToRootViewController(animated: false)
        }
    }
}
