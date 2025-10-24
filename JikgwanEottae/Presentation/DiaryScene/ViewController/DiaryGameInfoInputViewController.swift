//
//  DiaryGameInfoInputViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/1/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 직관 일기 작성을 위한 게임 정보 입력을 담당하는 뷰 컨트롤러입니다.

final class DiaryGameInfoInputViewController: UIViewController {
    private let diaryGameInfoInputView = DiaryGameInfoInputView()
    private let disposeBag = DisposeBag()
    private let viewModel: DiaryGameInfoInputViewModel
    private var cachedTeams: [String] = []
    
    init(viewModel: DiaryGameInfoInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryGameInfoInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        hideKeyboardWhenTappedAround()
        setupTextFieldDelegates()
        configureNavigationBarItem()
        bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }
    
    private func bindViewModel() {
        let input = DiaryGameInfoInputViewModel.Input(
            favoriteTeam: diaryGameInfoInputView.favoriteTeamTextField.textField.rx.text
                .orEmpty
                .asObservable(),
            seat: diaryGameInfoInputView.seatTextField.textField.rx.text
                .orEmpty
                .asObservable()
            ,
            nextButtonTapped: diaryGameInfoInputView.nextButton.rx.tap
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.teams
            .drive(onNext: { [weak self] teams in
                guard let self = self else { return }
                self.cachedTeams = teams
            })
            .disposed(by: disposeBag)
        
        
        output.inputData
            .subscribe(onNext: { [weak self] (gameId, favoriteTeam, seat) in
                guard let self = self else { return }
                if favoriteTeam.isEmpty {
                    self.showTeamRequiredAlert()
                    return
                }
                self.navigateToContentInput(
                    gameId: gameId,
                    favoriteTeam: favoriteTeam,
                    seat: seat
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTextFieldDelegates() {
        diaryGameInfoInputView.favoriteTeamTextField.textField.delegate = self
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: diaryGameInfoInputView.nextButton)
    }
    
    /// 응원팀 선택 바텀 시트를 표시합니다.
    private func presentTeamPickerSheet(with teams: [String]) {
        let textField = diaryGameInfoInputView.favoriteTeamTextField.textField
        diaryGameInfoInputView.highlightFavoriteTeamField(true)
        let sheetViewCont = BottomTableSheetViewController(
            title: "응원팀",
            items: teams,
            selectedItem: textField.text,
            sheetHeight: 250
        )
        
        sheetViewCont.onItemSelected = { [weak self, weak textField] selected in
            textField?.text = selected
            textField?.sendActions(for: .editingChanged)
            self?.diaryGameInfoInputView.highlightFavoriteTeamField(false)
        }
        
        sheetViewCont.onDismiss = { [weak self] in
            self?.diaryGameInfoInputView.highlightFavoriteTeamField(false)
        }
        
        sheetViewCont.modalPresentationStyle = .pageSheet
        present(sheetViewCont, animated: true)
    }
    
    /// 응원팀 필수 선택을 요구하는 알림창을 표시합니다.
    private func showTeamRequiredAlert() {
        showAlert(
            title: "알림",
            message: "응원팀을 필수로 선택해주세요",
            doneTitle: "닫기",
            doneStyle: .cancel
        )
    }
    
    /// 컨텐츠 입력 화면으로 이동합니다.
    private func navigateToContentInput(
        gameId: Int,
        favoriteTeam: String,
        seat: String
    ) {
        let repository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
        let useCase = DiaryUseCase(repository: repository)
        let viewModel = DiaryContentInputViewModel(
            gameId: gameId,
            favoriteTeam: favoriteTeam,
            seat: seat,
            useCase: useCase
        )
        let viewController = DiaryContentInputViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DiaryGameInfoInputViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == diaryGameInfoInputView.favoriteTeamTextField.textField {
            view.endEditing(true)
            presentTeamPickerSheet(with: cachedTeams)
            return false
        }
        return true
    }
}
