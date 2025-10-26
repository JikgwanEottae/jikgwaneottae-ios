//
//  FavoriteTeamEditViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/27/25.
//

import UIKit

import RxSwift
import RxCocoa

final class FavoriteTeamEditViewController: UIViewController {
    private let favoriteTeamEditView = FavoriteTeamEditView()
    private let viewModel: FavoriteTeamEditViewModel
    private var cachedTeams: [String] = []
    private let disposeBag = DisposeBag()
    
    init(viewModel: FavoriteTeamEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = favoriteTeamEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        hideKeyboardWhenTappedAround()
        bindViewModel()
        setupTextFieldDelegates()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    private func bindViewModel() {
        let input = FavoriteTeamEditViewModel.Input(
            favoriteTeam: favoriteTeamEditView.favoriteTeamInputField.textField.rx.text
                .orEmpty
                .asObservable(),
            completeButtonTapped: favoriteTeamEditView.completeButton.rx.tap
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.teams
            .drive(onNext: { [weak self] teams in
                guard let self = self else { return }
                self.cachedTeams = teams
            })
            .disposed(by: disposeBag)
        
        output.editSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        output.editFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(
                    title: "알림",
                    message: "응원팀 변경에 실패했어요",
                    doneTitle: "확인"
                )
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(favoriteTeamEditView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func setupTextFieldDelegates() {
        favoriteTeamEditView.favoriteTeamInputField.textField.delegate = self
    }
    
    /// 응원팀 선택 바텀 시트를 표시합니다.
    private func presentTeamPickerSheet(with teams: [String]) {
        let textField = favoriteTeamEditView.favoriteTeamInputField.textField
        favoriteTeamEditView.highlightFavoriteTeamField(true)
        let sheetViewCont = BottomTableSheetViewController(
            title: "응원팀",
            items: teams,
            selectedItem: textField.text,
            sheetHeight: 400
        )
        
        sheetViewCont.onItemSelected = { [weak self, weak textField] selected in
            textField?.text = selected
            textField?.sendActions(for: .editingChanged)
            self?.favoriteTeamEditView.highlightFavoriteTeamField(false)
        }
        
        sheetViewCont.onDismiss = { [weak self] in
            self?.favoriteTeamEditView.highlightFavoriteTeamField(false)
        }
        
        sheetViewCont.modalPresentationStyle = .pageSheet
        present(sheetViewCont, animated: true)
    }
}

extension FavoriteTeamEditViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == favoriteTeamEditView.favoriteTeamInputField.textField {
            view.endEditing(true)
            presentTeamPickerSheet(with: cachedTeams)
            return false
        }
        return true
    }
}
