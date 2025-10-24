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
    private let photoRelay = PublishRelay<Data?>()
    private var cachedTeams: [String] = []
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
        setupDelegates()
        configureNavigationBarItem()
        configureButtonActions()
        handleCloseBarButton()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            self.view.endEditing(true)
    }
    
    private func setupDelegates() {
        diaryEditView.contentTextView.delegate = self
        diaryEditView.favoriteTeamTextField.textField.delegate = self
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = diaryEditView.editBarButton
        self.navigationItem.leftBarButtonItem = diaryEditView.closeBarButton
    }
    
    private func configureButtonActions() {
        diaryEditView.photoSelectionButton.addTarget(
            self,
            action: #selector(handlePhotoSelectionButtonTapped),
            for: .touchUpInside
        )
        
        diaryEditView.removePhotoButton.addTarget(
            self,
            action: #selector(handlePhotoRemoveButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        let input = DiaryEditViewModel.Input(
            title: diaryEditView.titleTextField.rx.text
                .orEmpty
                .skip(1)
                .asObservable(),
            content: diaryEditView.contentTextView.rx.text
                .orEmpty
                .skip(1)
                .asObservable(),
            photo: photoRelay
                .asObservable(),
            favoriteTeam: diaryEditView.favoriteTeamTextField.textField.rx.text
                .orEmpty
                .skip(1)
                .asObservable(),
            seat: diaryEditView.seatTextField.textField.rx.text
                .orEmpty
                .skip(1)
                .asObservable(),
            editButtonTapped: diaryEditView.editBarButton.rx.tap
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.initialTitle
            .drive(diaryEditView.titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.initialContent
            .drive(onNext: { [weak self] content in
                guard let self = self else { return }
                self.diaryEditView.updateContentText(content)
            })
            .disposed(by: disposeBag)
        
        output.initialImageURL
            .drive(onNext: { [weak self] imageUrl in
                guard let self = self else { return }
                self.diaryEditView.configureImage(with: imageUrl)
            })
            .disposed(by: disposeBag)
        
        output.initialFavoriteTeam
            .drive(diaryEditView.favoriteTeamTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
        output.initialTeams
            .drive(onNext: { [weak self] teams in
                guard let self = self else { return }
                self.cachedTeams = teams
            })
            .disposed(by: disposeBag)
        
        output.initialSeat
            .drive(diaryEditView.seatTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
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
        
        output.isLoading
            .drive(diaryEditView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.editSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                guard let tabBar = owner.presentingViewController as? UITabBarController,
                      let navigation = tabBar.selectedViewController as? UINavigationController else { return }
                owner.dismiss(animated: true) {
                    navigation.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.editFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(
                    title: "알림",
                    message: "일기를 수정하지 못했어요",
                    doneTitle: "확인",
                    doneStyle: .cancel
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func handleCloseBarButton() {
        diaryEditView.closeBarButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - @objc

extension DiaryEditViewController {
    @objc
    private func handlePhotoSelectionButtonTapped() {
        presentPhotoPicker()
    }
    
    @objc
    private func handlePhotoRemoveButtonTapped() {
        diaryEditView.removePhoto()
        photoRelay.accept(nil)
    }
}

// MARK: - UITextViewDelegate

extension DiaryEditViewController: UITextViewDelegate {
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

// MARK: - UITextFieldDelegate

extension DiaryEditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == diaryEditView.favoriteTeamTextField.textField {
            view.endEditing(true)
            presentTeamPickerSheet(with: cachedTeams)
            return false
        }
        return true
    }
}

extension DiaryEditViewController {
    /// 응원팀 선택 바텀 시트를 표시합니다.
    private func presentTeamPickerSheet(with teams: [String]) {
        let textField = diaryEditView.favoriteTeamTextField.textField
        diaryEditView.highlightFavoriteTeamField(true)
        let sheetViewCont = BottomTableSheetViewController(
            title: "응원팀",
            items: teams,
            selectedItem: textField.text,
            sheetHeight: 250
        )
        
        sheetViewCont.onItemSelected = { [weak self, weak textField] selected in
            textField?.text = selected
            textField?.sendActions(for: .editingChanged)
            self?.diaryEditView.highlightFavoriteTeamField(false)
        }
        
        sheetViewCont.onDismiss = { [weak self] in
            self?.diaryEditView.highlightFavoriteTeamField(false)
        }
        
        sheetViewCont.modalPresentationStyle = .pageSheet
        present(sheetViewCont, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension DiaryEditViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self, let selectedImage = object as? UIImage else { return }
            photoRelay.accept(selectedImage.jpegData(compressionQuality: 0.8))
            DispatchQueue.main.async {
                self.diaryEditView.didPickImage(selectedImage)
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
