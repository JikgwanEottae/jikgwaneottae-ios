//
//  NicknameEditViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/6/25.
//

import UIKit

import RxSwift
import RxCocoa

final class NicknameEditViewController: UIViewController {
    private let nicknameEditView = NicknameEditView()
    private let viewModel: NicknameEditViewModel
    public var onNicknameUpdated: (() -> Void)?
    private let isInitialEdit: Bool
    private let disposeBag = DisposeBag()
    
    init(viewModel: NicknameEditViewModel, isInitialEdit: Bool) {
        self.viewModel = viewModel
        self.isInitialEdit = isInitialEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = nicknameEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        hideKeyboardWhenTappedAround()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = NicknameEditViewModel.Input(
            nickname: nicknameEditView.nicknameInputField.textField.rx.text.orEmpty.asObservable(),
            completeButtonTapped: nicknameEditView.completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(nicknameEditView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.success
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                if owner.isInitialEdit {
                    let mainTabBarController = MainTabBarController()
                    owner.transitionRoot(to: mainTabBarController)
                } else {
                    guard let nickname = UserDefaultsManager.shared.nickname else { return }
                    owner.onNicknameUpdated?()
                    owner.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.error
            .withUnretained(self)
            .emit(onNext: { owner, error in
                owner.showAlert(
                    title: "변경 실패",
                    message: "이미 다른 사용자가 사용하고 있어요",
                    doneTitle: "확인"
                )
            })
            .disposed(by: disposeBag)
        
        output.validation
            .drive(nicknameEditView.noticeLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension NicknameEditViewController {
    private func transitionRoot(to viewController: UIViewController) {
        if let scene = self.view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelate = scene.delegate as? SceneDelegate {
            sceneDelate.changeRootViewController(to: viewController)
        }
    }
}
