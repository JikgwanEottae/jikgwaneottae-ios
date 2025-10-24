//
//  DiaryDetailViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/28/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 직관 일기 상세보기를 위한 뷰 컨트롤러입니다.

final class DiaryDetailViewController: UIViewController {
    private let diaryDetailView = DiaryDetailView()
    private let viewModel: DiaryDetailViewModel
    private let editButtonRelay = PublishRelay<Void>()
    private let deleteButtonRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        hideKeyboardWhenTappedAround()
        configureNavigationBarItem()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = DiaryDetailViewModel.Input(
            editButtonTapped: editButtonRelay.asObservable(),
            deleteButtonTapped: deleteButtonRelay.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.imageURL
            .drive(onNext: { [weak self] urlString in
                guard let self = self else { return }
                self.diaryDetailView.configureImage(with: urlString)
            })
            .disposed(by: disposeBag)
        
        output.title
            .drive(diaryDetailView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.gameInfo
            .drive(diaryDetailView.gameInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.metaInfo
            .drive(diaryDetailView.metaInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.content
            .drive(diaryDetailView.contentTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.date
            .drive(diaryDetailView.dateInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.result
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(diaryDetailView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.deleteSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.deleteFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(
                    title: "일기를 삭제하지 못했어요",
                    doneTitle: "확인",
                    doneStyle: .cancel
                )
            })
            .disposed(by: disposeBag)
        
        output.editDiary
            .withUnretained(self)
            .emit(onNext: { owner, diary in
                owner.naviagateToDiaryEditScene(diary)
            })
            .disposed(by: disposeBag)
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        let ellipsisButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis", withConfiguration: config),
            style: .plain,
            target: nil,
            action: nil
        )
        let editAction = UIAction(
            title: "수정",
            image: UIImage(systemName: "pencil")
        ) { [weak self] _ in
            self?.handleEdit()
        }
        let deleteAction = UIAction(
            title: "삭제",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { [weak self] _ in
            self?.handleDelete()
        }
        let menu = UIMenu(
            title: "메뉴",
            children: [editAction, deleteAction]
        )
        ellipsisButtonItem.menu = menu
        ellipsisButtonItem.primaryAction = nil
        ellipsisButtonItem.tintColor = UIColor.Text.secondaryColor
        self.navigationItem.rightBarButtonItem = ellipsisButtonItem
    }

}


extension DiaryDetailViewController {
    private func handleEdit() {
        editButtonRelay.accept(())
    }

    private func handleDelete() {
        showAlert(
            title: "알림",
            message: "일기를 삭제할까요?",
            doneTitle: "삭제",
            doneStyle: .destructive,
            cancelTitle: "취소",
            cancelStyle: .cancel,
            doneCompletion: { [weak self]  in
                self?.deleteButtonRelay.accept(())
            })
    }
}


extension DiaryDetailViewController {
    private func naviagateToDiaryEditScene(_ diary: Diary) {
        let repository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
        let useCase = DiaryUseCase(repository: repository)
        let viewModel = DiaryEditViewModel(useCase: useCase, diary: diary)
        let viewController = DiaryEditViewController(viewModel: viewModel)
        let naviController = UINavigationController(rootViewController: viewController)
        naviController.modalPresentationStyle = .overFullScreen
        naviController.configureBarAppearnace()
        self.present(naviController, animated: true)
    }
}
