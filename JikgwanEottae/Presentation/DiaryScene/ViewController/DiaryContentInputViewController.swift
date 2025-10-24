//
//  DiaryContentInputViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/19/25.
//

import PhotosUI
import UIKit

import RxSwift
import RxCocoa

final class DiaryContentInputViewController: UIViewController {
    private let diaryContentInputView = DiaryContentInputView()
    private let photoRelay = BehaviorRelay<Data?>(value: nil)
    private let viewModel: DiaryContentInputViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryContentInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryContentInputView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupTextViewDelegate()
        configureButtonActions()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.view.endEditing(true)
    }
    
    private func bindViewModel() {
        let input = DiaryContentInputViewModel.Input(
            title: diaryContentInputView.titleTextField.rx.text
                .orEmpty
                .asObservable(),
            content: diaryContentInputView.memoTextView.rx.text
                .orEmpty
                .asObservable(),
            photo: photoRelay
                .asObservable(),
            submitButtonTapped: diaryContentInputView.completeButton.rx.tap
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.showEmptyAlert
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(
                    title: "알림",
                    message: "제목을 필수로 입력해주세요",
                    doneTitle: "닫기",
                    doneStyle: .cancel
                )
            })
            .disposed(by: disposeBag)
        
        output.createSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.createFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(
                    title: "일기를 작성하지 못했어요",
                    doneTitle: "확인",
                    doneStyle: .cancel
                )
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(diaryContentInputView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func setupTextViewDelegate() {
        diaryContentInputView.memoTextView.delegate = self
    }
    
    private func configureButtonActions() {
        diaryContentInputView.photoSelectionButton.addTarget(
            self,
            action: #selector(handlePhotoSelectionButtonTapped),
            for: .touchUpInside
        )
        
        diaryContentInputView.removePhotoButton.addTarget(
            self,
            action: #selector(handlePhotoRemoveButtonTapped),
            for: .touchUpInside
        )
    }
}

// MARK: - @objc

extension DiaryContentInputViewController {
    @objc
    private func handlePhotoSelectionButtonTapped() {
        presentPhotoPicker()
    }
    
    @objc
    private func handlePhotoRemoveButtonTapped() {
        diaryContentInputView.removePhoto()
        photoRelay.accept(nil)
    }
}

// MARK: - UITextViewDelegate

extension DiaryContentInputViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.Text.placeholderColor {
            textView.text = nil
            textView.textColor = UIColor.Text.tertiaryColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.Text.textViewPlaceholder
            textView.textColor = UIColor.Text.placeholderColor
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension DiaryContentInputViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self, let selectedImage = object as? UIImage else { return }
            photoRelay.accept(selectedImage.jpegData(compressionQuality: 0.8))
            DispatchQueue.main.async {
                self.diaryContentInputView.didPickImage(selectedImage)
            }
        }
    }
}

extension DiaryContentInputViewController {
    ///  PHPickerViewController를 띄워줍니다.
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}
