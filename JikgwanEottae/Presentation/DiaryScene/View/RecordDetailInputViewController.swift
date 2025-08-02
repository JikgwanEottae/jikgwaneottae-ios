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

final class RecordDetailInputViewController: UIViewController {

    
    
    private let recordDetailInputView = RecordDetailInputView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = recordDetailInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        hideKeyboardWhenTappedAround()
        photoSelectionButtonTapped()
        photoRemoveButtonTapped()
    }
    
    private func setupDelegate() {
        recordDetailInputView.reviewTextView.delegate = self
    }
    
    private func photoSelectionButtonTapped() {
        recordDetailInputView.selectPhotoButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentPhotoPicker()
            }
            .disposed(by: disposeBag)
    }
    
    private func photoRemoveButtonTapped() {
        recordDetailInputView.removePhotoButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.recordDetailInputView.removePhoto()
            }
            .disposed(by: disposeBag)
    }
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        // 최대로 선택 가능한 수
        config.selectionLimit = 1
        // 이미지만 선택 가능
        config.filter = .images
        // picker 생성
        let picker = PHPickerViewController(configuration: config)
        // 델리게이트 설정
        picker.delegate = self
        present(picker, animated: true)
    }

}

// MARK: - UITextViewDelegate extension

extension RecordDetailInputViewController: UITextViewDelegate {
    // MARK: - textViewDidBeginEditing
    public func textViewDidBeginEditing(_ textView: UITextView) {
        // 텍스트뷰의 텍스트 컬러가 placeholderText일 경우. 즉 텍스트가 없는 상태
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .primaryTextColor
        }
    }
    
    // MARK: - textViewDidEndEditing
    public func textViewDidEndEditing(_ textView: UITextView) {
        // 사용자가 입력을 하지 않았을 때
        if textView.text.isEmpty {
            // placeholder 설정
            textView.text = RecordDetailInputView.memoTextViewPlaceholderText
            textView.textColor = .placeholderText
        }
    }
}

extension RecordDetailInputViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커 창 닫기
        picker.dismiss(animated: true)
        // 선택된 사진들 중 첫 번째 사진만 가져오기
        guard let result = results.first else { return }
        let provider = result.itemProvider
        // 오브젝트를 UIImage로 로드 가능한지 체크
        guard provider.canLoadObject(ofClass: UIImage.self) else { return }
        // 비동기로 UIImage 로드
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let error = error { return }
                guard let selectedImage = object as? UIImage else { return }
                self.recordDetailInputView.didPickImage(selectedImage)
                self.recordDetailInputView.removePhotoButton.isHidden = false
            }
        }
    }
}

