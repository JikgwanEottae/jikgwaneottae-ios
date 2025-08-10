//
//  RecordDetailInputViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/28/25.
//

import PhotosUI
import UIKit

import RxCocoa
import RxSwift

final class DiaryEditViewController: UIViewController {
    private let diaryEditView: DiaryEditView
    private let viewModel: DiaryEditViewModel
    private let disposeBag = DisposeBag()
    private var selectedPhotoDataRelay = PublishRelay<Data?>()
    
    init(viewModel: DiaryEditViewModel) {
        self.viewModel = viewModel
        self.diaryEditView = DiaryEditView(gameInfo: viewModel.selectedKBOGame)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        bindViewModel()
        hideKeyboardWhenTappedAround()
        photoSelectionButtonTapped()
        photoRemoveButtonTapped()
    }
    
    private func setupDelegate() {
        diaryEditView.memoTextView.delegate = self
    }
    
    private func bindViewModel() {
        let teamSegmentControl = diaryEditView.teamSegmentControl
        
        let input = DiaryEditViewModel.Input(
            createButtonTapped: diaryEditView.createButton.rx
                .tap
                .asObservable(),
            favoriteTeam: diaryEditView.teamSegmentControl.rx
                .controlEvent(.valueChanged)
                .map { teamSegmentControl.selectedTeam }
                .asObservable(),
            seatText: diaryEditView.seatInputFieldView.textField.rx
                .text
                .asObservable(),
            memoText: diaryEditView.memoTextView.rx
                .text
                .asObservable(),
            selectedPhotoData: selectedPhotoDataRelay
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                self?.diaryEditView.interactionBlocker.isHidden = !isLoading
                isLoading ? self?.showLoadingIndicator() : self?.hideLoadingIndicator()
            })
            .disposed(by: disposeBag)
        
        output.editResult
            .withUnretained(self)
            .emit(onNext: { owner, result in
                switch result {
                case .success:
                    owner.presentPopup()
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func photoSelectionButtonTapped() {
        diaryEditView.selectPhotoButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentPhotoPicker()
            }
            .disposed(by: disposeBag)
    }
    
    private func photoRemoveButtonTapped() {
        diaryEditView.removePhotoButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.diaryEditView.removePhoto()
            }
            .disposed(by: disposeBag)
    }
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentPopup() {
        let popupViewController = PopupViewController(
            titleText: "작성 완료",
            subtitleText: "캘린더에서 일기를 확인해보세요"
        )
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.modalTransitionStyle = .crossDissolve
        popupViewController.onConfirm = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        present(popupViewController, animated: true)
    }
    
    private func showLoadingIndicator() {
        self.diaryEditView.activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        self.diaryEditView.activityIndicator.stopAnimating()
    }
    


}

// MARK: - UITextViewDelegate extension

extension DiaryEditViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        // 텍스트뷰의 텍스트 컬러가 placeholderText일 경우. 즉 텍스트가 없는 상태
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .primaryTextColor
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        // 사용자가 입력을 하지 않았을 때
        if textView.text.isEmpty {
            // placeholder 설정
            textView.text = DiaryEditView.memoTextViewPlaceholderText
            textView.textColor = .placeholderText
        }
    }
}

// MARK: - PHPickerViewControllerDelegate extension

extension DiaryEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self, let selectedImage = object as? UIImage else { return }
            DispatchQueue.global(qos: .background).async {
                self.selectedPhotoDataRelay.accept(selectedImage.jpegData(compressionQuality: 0.8))
                DispatchQueue.main.async {
                    self.diaryEditView.didPickImage(selectedImage)
                    self.diaryEditView.removePhotoButton.isHidden = false
                }
            }
        }
    }
}

