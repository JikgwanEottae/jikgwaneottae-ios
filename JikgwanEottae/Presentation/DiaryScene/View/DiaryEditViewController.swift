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
    private let diaryEditView = DiaryEditView()
    private let viewModel: DiaryEditViewModel
    private let disposeBag = DisposeBag()
    private var selectedPhotoDataRelay = PublishRelay<Data?>()
    
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
        setupBarButtonItems()
        setupDelegate()
        bindViewModel()
        hideKeyboardWhenTappedAround()
        photoSelectionButtonTapped()
        photoRemoveButtonTapped()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        diaryEditView.teamSegmentControl.layoutIfNeeded()
        diaryEditView.teamSegmentControl.updateUI(animated: true)
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = diaryEditView.deleteDiaryBarButtonItem
        diaryEditView.deleteDiaryBarButtonItem.rx.tap
            .withUnretained(self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.presentDeletePopup()
            })
            .disposed(by: disposeBag)
    }
    
    /// 델리게이트를 설정합니다.
    private func setupDelegate() {
        diaryEditView.memoTextView.delegate = self
    }
    
    /// 뷰 모델과 바인딩합니다.
    private func bindViewModel() {
        let teamSegmentControl = diaryEditView.teamSegmentControl
        
        let input = DiaryEditViewModel.Input(
            // 직관 일기 생성 버튼 클릭 이벤트입니다.
            createButtonTapped: diaryEditView.createButton.rx
                .tap
                .asObservable(),
            
//            // 직관 일기 삭제 버튼 클릭 이벤트입니다.
//            deleteButtonTapped: diaryEditView.deleteDiaryBarButtonItem.rx
//                .tap
//                .asObservable(),
            
            // 팀 선택 세그먼트 컨트롤 이벤트입니다.
            favoriteTeam: diaryEditView.teamSegmentControl.rx
                .controlEvent(.valueChanged)
                .map { teamSegmentControl.selectedTeam }
                .distinctUntilChanged()
                .asObservable(),
            
            seatText: diaryEditView.seatInputFieldView.textField.rx
                .text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            
            memoText: diaryEditView.memoTextView.rx
                .text
                .orEmpty
                .distinctUntilChanged()
                .asObservable(),
            
            selectedPhotoData: selectedPhotoDataRelay
                .startWith(nil)
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        // 직관 일기의 모드를 직관 일기 삭제 바 버튼 아이템과 연결합니다.
        output.isCreateMode
            .emit(to: diaryEditView.deleteDiaryBarButtonItem.rx.isHidden)
            .disposed(by: disposeBag)
        
        // 홈팀 및 어웨이팀 그리고 응원팀을 세그먼트 컨트롤과 연결합니다.
        Driver.zip(
            output.initialHomeTeam,
            output.initialAwayTeam,
            output.initialFavoriteTeam
        ).drive(onNext: { [weak self] homeTeam, awayTeam, favoriteTeam in
            self?.diaryEditView.teamSegmentControl.configure(
                homeTeam: homeTeam,
                awayTeam: awayTeam,
                favoriteTeam: favoriteTeam
            )
        })
        .disposed(by: disposeBag)
        
        // 초기 좌석 상태를 텍스트 필드와 연결합니다.
        output.initialSeat
            .drive(diaryEditView.seatInputFieldView.textField.rx.text)
            .disposed(by: disposeBag)
        
        // 초기 메모 상태를 텍스트 뷰와 연결합니다.
        output.initialMemo
            .drive(onNext: { [weak self] memoText in
                self?.diaryEditView.configureMemoText(memoText)
            })
            .disposed(by: disposeBag)
        
        // 초기 이미지 상태를 버튼의 이미지와 연결합니다.
        output.initialPhotoData
            .drive(onNext: { [weak self] photoURL in
                guard let self = self, let url = photoURL else { return }
                self.diaryEditView.configurePhoto(url)
            })
            .disposed(by: disposeBag)
        
        // 네트워크 통신 중 로딩 인디케이터를 보여줍니다.
        output.isLoading
            .drive(diaryEditView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // 네트워크 통신 후 성공/실패 결과를 보여줍니다.
        output.editResult
            .withUnretained(self)
            .emit(onNext: { owner, result in
                switch result {
                case .success:
                    owner.view.endEditing(true)
                    owner.presentPopup()
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 직관 인증 사진을 업로드하는 버튼 클릭 이벤트를 받습니다.
    private func photoSelectionButtonTapped() {
        diaryEditView.selectPhotoButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentPhotoPicker()
            }
            .disposed(by: disposeBag)
    }
    
    /// 직관 인증 사진을 제거하는 버튼 클릭 이벤트를 받습니다.
    private func photoRemoveButtonTapped() {
        diaryEditView.removePhotoButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.diaryEditView.removePhoto()
            }
            .disposed(by: disposeBag)
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
                    self.diaryEditView.didPickPhoto(selectedImage)
                    self.diaryEditView.removePhotoButton.isHidden = false
                }
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
    
    /// 직관 일기를 생성했을 때 성공 팝업을 표시합니다.
    private func presentPopup() {
//        let popupViewController = PopupViewController(
//            titleText: "작성 완료",
//            subtitleText: "캘린더에서 일기를 확인해보세요"
//        )
//        popupViewController.modalPresentationStyle = .overFullScreen
//        popupViewController.modalTransitionStyle = .crossDissolve
//        popupViewController.onConfirm = { [weak self] in
//            self?.navigationController?.popToRootViewController(animated: true)
//        }
//        present(popupViewController, animated: true)
    }
    
    /// // 직관 일기 삭제 버튼 클릭에 따른 팝업을 표시합니다.
    private func presentDeletePopup() {
        let popupViewController = PopupViewController(
            title: "일기 삭제",
            subtitle: "정말로 일기를 삭제할까요?",
            mainButtonStyle: .init(title: "삭제", backgroundColor: .tossRedColor),
            subButtonStyle: .init(title: "취소", backgroundColor: .primaryBackgroundColor),
            blurEffect: .init(style: .systemUltraThinMaterialDark))
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.modalTransitionStyle = .crossDissolve
        popupViewController.onMainAction = { [weak self] in

        }
        present(popupViewController, animated: true)
    }
}
