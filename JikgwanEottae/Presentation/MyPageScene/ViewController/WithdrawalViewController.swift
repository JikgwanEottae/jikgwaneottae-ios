//
//  WithdrawalViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/10/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 회원탈퇴를 진행하기 위한 뷰 컨트롤러입니다.

final class WithdrawalViewController: UIViewController {
    private let withdrawalView = WithdrawalView()
    private let viewModel: WithdrawalViewModel
    weak var delegate: SignOutDelegate?
    private let withdrawButtonRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: WithdrawalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = withdrawalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        withdrawButtonTapped()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = WithdrawalViewModel.Input(
            withdrawButtonTapped: withdrawButtonRelay.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(withdrawalView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        output.withdrawalSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.handleSignOutComplete()
            })
            .disposed(by: disposeBag)
    }
    
    /// 탈퇴하기 버튼 클릭 이벤트입니다.
    private func withdrawButtonTapped() {
        withdrawalView.withdrawButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.presentWithdrawAlert()
            })
            .disposed(by: disposeBag)
    }
    
    /// 회원탈퇴 팝업 화면을 표시합니다.
    private func presentWithdrawAlert() {
        HapticFeedbackManager.shared.light()
        self.showAlert(
            title: "회원탈퇴",
            message: "정말 회원을 탈퇴할까요?",
            doneTitle: "탈퇴",
            doneStyle: .destructive,
            cancelTitle: "닫기",
            cancelStyle: .cancel,
            doneCompletion: { [weak self] in
                self?.withdrawButtonRelay.accept(())
            }
        )
    }
    
    /// 회원탈퇴 팝업 화면의 로딩 인디케이터 상태를 업데이트합니다.
    private func updateSignOutPopupLoadingState(isLoading: Bool) {
        guard let popupViewController = self.presentedViewController as? PopupViewController else{ return }
        popupViewController.updateActivityIndicatorState(isLoading)
    }
    
    /// 게스트 모드로 전환합니다.
    private func handleSignOutComplete() {
        self.delegate?.signOutDidComplete()
        self.navigationController?.popViewController(animated: true)
    }
}
