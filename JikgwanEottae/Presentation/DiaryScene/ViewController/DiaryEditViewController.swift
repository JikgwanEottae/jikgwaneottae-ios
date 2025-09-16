//
//  DiaryEditViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/28/25.
//

import PhotosUI
import UIKit

import RxSwift
import RxCocoa

final class DiaryEditViewController: UIViewController {
    private let diaryEditView = DiaryEditView()
    private let viewModel: DiaryEditViewModel
    private let selectedPhotoDataRelay = PublishRelay<Data?>()
    private let deleteButtonTappedRelay = PublishRelay<Void>()
    private let photoChangedStateRelay = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryEditViewModel) {
        self.viewModel = viewModel
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
        hideKeyboardWhenTappedAround()
        configureNavigationBarItem()
        bindViewModel()
        bindUnderlineColorToEditingState()
        bindPhotoSelectionButton()
        bindPhotoRemoveButton()
        setupPickerView()
        setupToolBar()
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: diaryEditView.dismissButton)
        diaryEditView.dismissButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: diaryEditView.deleteButton)
        diaryEditView.deleteButton.addTarget(self, action: #selector(deleteDiary), for: .touchUpInside)
    }
    
    /// 피커 뷰를 설정합니다.
    private func setupPickerView() {
        // 선택된 응원팀 아이템을 텍스트 필드와 바인드합니다.
        diaryEditView.supportTeamPickerView.rx.modelSelected(String.self)
            .compactMap { $0.first }
            .bind(to: diaryEditView.supportTeamInputField.textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = DiaryEditViewModel.Input(
            selectedPhotoData: selectedPhotoDataRelay,
            supportTeam: diaryEditView.supportTeamInputField.textField.rx.text.orEmpty.asObservable(),
            seat: diaryEditView.seatInputField.textField.rx.text.orEmpty.asObservable(),
            memo: diaryEditView.memoInputField.textField.rx.text.orEmpty.asObservable(),
            isPhotoChanged: photoChangedStateRelay,
            updateButtonTapped: diaryEditView.updateButton.rx.tap.asObservable(),
            deleteButtonTapped: deleteButtonTappedRelay.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.initialPhoto
            .drive(onNext: { [weak self] photoURL in
                self?.diaryEditView.configureImage(photoURL)
            })
            .disposed(by: disposeBag)
        
        output.supportTeamPickerItems
            .drive(diaryEditView.supportTeamPickerView.rx.itemTitles) { _, team in
                return team
            }
            .disposed(by: disposeBag)
        
        output.initialSupportTeam
            .drive(diaryEditView.supportTeamInputField.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.initialSeat
            .drive(diaryEditView.seatInputField.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.initialMemo
            .drive(diaryEditView.memoInputField.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(diaryEditView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.updateSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(title: "수정 완료", message: "직관 기록을 수정했어요", doneTitle: "확인", doneCompletion: { [weak self] in
                    self?.view.endEditing(true)
                    self?.dismiss(animated: true)
                })
            })
            .disposed(by: disposeBag)
        
        output.updateFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(title: "수정 실패", message: "잠시 후 다시 시도해주세요", doneTitle: "확인")
            })
            .disposed(by: disposeBag)
        
        output.deleteSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.deleteFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(title: "삭제 실패", message: "잠시 후 다시 시도해주세요", doneTitle: "확인")
            })
            .disposed(by: disposeBag)
        
        output.formInputError
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(title: "안내", message: "응원팀은 필수로 선택해주세요", doneTitle: "확인")
            })
            .disposed(by: disposeBag)
        
    }
    
    /// 툴바를 설정합니다.
    private func setupToolBar() {
        diaryEditView.setupToolBar(target: self, action: #selector(dismissPicker))
    }
    
    /// 언더라인을 편집 상태와 바인드하여 색상을 업데이트합니다.
    private func bindUnderlineColorToEditingState() {
        let textFields = [
            diaryEditView.supportTeamInputField.textField,
            diaryEditView.seatInputField.textField,
            diaryEditView.memoInputField.textField
        ]
        
        let inputFields = [
            diaryEditView.supportTeamInputField,
            diaryEditView.seatInputField,
            diaryEditView.memoInputField
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
    
    /// 사진을 업로드하는 이벤트입니다.
    private func bindPhotoSelectionButton() {
        diaryEditView.selectImageButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentPhotoPicker()
            }
            .disposed(by: disposeBag)
    }
    
    /// 사진을 제거하는 이벤트입니다.
    private func bindPhotoRemoveButton() {
        diaryEditView.removePhotoButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.diaryEditView.removeImage()
                owner.selectedPhotoDataRelay.accept(nil)
                owner.photoChangedStateRelay.accept(true)
            }
            .disposed(by: disposeBag)
    }
}

extension DiaryEditViewController {
    /// 툴바의 Done 버튼이 클릭됬을 때 툴바를 닫습니다.
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
    
    /// 뷰 컨트롤러를 닫습니다.
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }

    /// 직관 일기를 삭제합니다.
    @objc private func deleteDiary() {
        self.showAlert(title: "기록 삭제", message: "정말로 직관 기록을 삭제할까요?", doneTitle: "삭제", doneStyle: .destructive, cancelTitle: "취소", cancelStyle: .cancel, doneCompletion: { [weak self] in
            self?.deleteButtonTappedRelay.accept(())
        })
    }
}

extension DiaryEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self, let selectedImage = object as? UIImage else { return }
            self.selectedPhotoDataRelay.accept(selectedImage.jpegData(compressionQuality: 0.8))
            self.photoChangedStateRelay.accept(true)
            DispatchQueue.main.async {
                self.diaryEditView.didPickImage(selectedImage)
                self.diaryEditView.removePhotoButton.isHidden = false
            }
        }
    }
}

extension DiaryEditViewController {
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
