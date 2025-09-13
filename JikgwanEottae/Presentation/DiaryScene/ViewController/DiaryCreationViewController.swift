//
//  DiaryCreationViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/12/25.
//

import PhotosUI
import UIKit

import RxSwift
import RxCocoa

final class DiaryCreationViewController: UIViewController {
    private let diaryCreationView = DiaryCreationView()
    private let viewModel: DiaryCreationViewModel
    private let selectedPhotoDataRelay = PublishRelay<Data?>()
    private let photoChangedStateRelay = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryCreationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryCreationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupPickerView()
        setupToolBar()
        bindViewModel()
        bindUnderlineColorToEditingState()
        bindPhotoSelectionButton()
        bindPhotoRemoveButton()
    }
    
    /// 피커 뷰를 설정합니다.
    private func setupPickerView() {
        // 선택된 응원팀 아이템을 텍스트 필드와 바인드합니다.
        diaryCreationView.supportTeamPickerView.rx.modelSelected(String.self)
            .compactMap { $0.first }
            .bind(to: diaryCreationView.supportTeamInputField.textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = DiaryCreationViewModel.Input(
            selectedPhotoData: selectedPhotoDataRelay,
            supportTeam: diaryCreationView.supportTeamInputField.textField.rx.text.orEmpty.asObservable(),
            seat: diaryCreationView.seatInputField.textField.rx.text.orEmpty.asObservable(),
            memo: diaryCreationView.memoInputField.textField.rx.text.orEmpty.asObservable(),
            isPhotoChanged: photoChangedStateRelay,
            createButtonTapped: diaryCreationView.recordButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.supportTeamPickerItems
            .drive(diaryCreationView.supportTeamPickerView.rx.itemTitles) { _, team in
                return team
            }
            .disposed(by: disposeBag)
        
        output.title
            .drive(onNext: { [weak self] title in
                guard let self = self else { return }
                self.title = title
            })
            .disposed(by: disposeBag)
        
        output.formError
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(title: "입력 안내", message: "응원팀은 필수로 선택해주세요", doneTitle: "확인")
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(diaryCreationView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.creationSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(title: "기록 완료", message: "직관 기록을 작성했어요", doneTitle: "확인", doneCompletion: { [weak self] in
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            })
            .disposed(by: disposeBag)
        
        output.creationFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(title: "기록 실패", message: "잠시 후 다시 시도해주세요", doneTitle: "확인")
            })
            .disposed(by: disposeBag)
    }
    
    /// 툴바를 설정합니다.
    private func setupToolBar() {
        diaryCreationView.setupToolBar(target: self, action: #selector(dismissPicker))
    }
    
    /// 언더라인을 편집 상태와 바인드하여 색상을 업데이트합니다.
    private func bindUnderlineColorToEditingState() {
        let textFields = [
            diaryCreationView.supportTeamInputField.textField,
            diaryCreationView.seatInputField.textField,
            diaryCreationView.memoInputField.textField
        ]
        
        let inputFields = [
            diaryCreationView.supportTeamInputField,
            diaryCreationView.seatInputField,
            diaryCreationView.memoInputField
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
        diaryCreationView.selectImageButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentPhotoPicker()
            }
            .disposed(by: disposeBag)
    }
    
    /// 사진을 제거하는 이벤트입니다.
    private func bindPhotoRemoveButton() {
        diaryCreationView.removeImageButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.diaryCreationView.removeImage()
                owner.selectedPhotoDataRelay.accept(nil)
                owner.photoChangedStateRelay.accept(true)
            }
            .disposed(by: disposeBag)
    }
}

extension DiaryCreationViewController {
    /// 툴바의 Done 버튼이 클릭됬을 때 툴바를 닫습니다.
    @objc private func dismissPicker() {
        view.endEditing(true)
    }
}

extension DiaryCreationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self, let selectedImage = object as? UIImage else { return }
            self.selectedPhotoDataRelay.accept(selectedImage.jpegData(compressionQuality: 0.8))
            self.photoChangedStateRelay.accept(true)
            DispatchQueue.main.async {
                self.diaryCreationView.didPickImage(selectedImage)
                self.diaryCreationView.removeImageButton.isHidden = false
            }
        }
    }
}

extension DiaryCreationViewController {
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
