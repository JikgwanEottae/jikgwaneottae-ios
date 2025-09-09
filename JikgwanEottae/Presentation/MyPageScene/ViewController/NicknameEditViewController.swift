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
    private let disposeBag = DisposeBag()
    
    init(viewModel: NicknameEditViewModel) {
        self.viewModel = viewModel
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
        bindUnderlineColorToEditingState()
        print("accessToken: \(KeychainManager.shared.readAccessToken())")
        print("refreshToken: \(KeychainManager.shared.readRefreshToken())")
        print("isProfileCompleted: \(UserDefaultsManager.shared.isProfileCompleted)")
        print("nickname: \(UserDefaultsManager.shared.nickname)")
        print("profileImageURL: \(UserDefaultsManager.shared.profileImageURL)")
    }
    
    private func bindViewModel() {
        let input = NicknameEditViewModel.Input(
            nickname: nicknameEditView.nicknameInputField.textField.rx.text.orEmpty.asObservable(),
            completeButtonTapped: nicknameEditView.completeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isButtonEnabled
            .withUnretained(self)
            .subscribe(onNext: { owner, isEnabled in
                owner.nicknameEditView.setButtonState(isEnabled)
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(nicknameEditView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.success
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let mainTabBarController = MainTabBarController()
                owner.transitionRoot(to: mainTabBarController)
            })
            .disposed(by: disposeBag)
        
        output.error
            .withUnretained(self)
            .subscribe(onNext: { owner, error in
                owner.showAlert(title: "실패", message: "이미 다른 사용자가 사용하고 있어요")
            })
            .disposed(by: disposeBag)
        
        output.validation
            .drive(nicknameEditView.noticeLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func bindUnderlineColorToEditingState() {
        nicknameEditView.nicknameInputField.textField.rx.controlEvent(.editingDidBegin)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                UIView.animate(withDuration: 0.25) {
                    owner.nicknameEditView.nicknameInputField.setUnderlineColor(.mainCharcoalColor)
                }
            })
            .disposed(by: disposeBag)
        
        nicknameEditView.nicknameInputField.textField.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                UIView.animate(withDuration: 0.25) {
                    owner.nicknameEditView.nicknameInputField.setUnderlineColor(.primaryBackgroundColor)
                }
            })
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
