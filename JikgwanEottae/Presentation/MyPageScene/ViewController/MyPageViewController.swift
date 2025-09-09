//
//  MyPageViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/7/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    private let signOutButtonRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let sectionTitles = ["내 정보", "기타"]
    private let items = [
        ["프로필 사진 설정", "닉네임 설정"],
        ["이용약관", "개인정보 처리방침", "로그아웃", "회원탈퇴"]
    ]
    
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        configureNaviBarButtonItem()
        setupDelegates()
        setupTableViewHeader()
        bindViewModel()
        bindTableView()
        print("accessToken: \(KeychainManager.shared.readAccessToken())")
        print("refreshToken: \(KeychainManager.shared.readRefreshToken())")
        print("isProfileCompleted: \(UserDefaultsManager.shared.isProfileCompleted)")
        print("nickname: \(UserDefaultsManager.shared.nickname)")
        print("profileImageURL: \(UserDefaultsManager.shared.profileImageURL)")
    }
    
    private func configureNaviBarButtonItem() {
        let leftBarButtonItem = UIBarButtonItem(customView: myPageView.titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    /// 델리게이트를 설정합니다.
    private func setupDelegates() {
        myPageView.tableView.delegate = self
        myPageView.tableView.dataSource = self
    }
    
    /// 테이블 뷰의 헤더를 설정합니다.
    private func setupTableViewHeader() {
        myPageView.headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 220)
        myPageView.tableView.tableHeaderView = myPageView.headerView
    }
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(
            signOutButtonTapped: signOutButtonRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.updateSignOutPopupLoadingState(isLoading: isLoading)
            })
            .disposed(by: disposeBag)

        output.signOutSuccess
            .emit(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismissPopupAndNavigateToLogin()
            })
            .disposed(by: disposeBag)
    }
    
    /// 테이블 뷰의 셀 클릭 이벤트를 처리합니다.
    private func bindTableView() {
        myPageView.tableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, indexPath in
                let selectedTitle = owner.items[indexPath.section][indexPath.row]
                owner.handleCellSelection(title: selectedTitle)
            })
            .disposed(by: disposeBag)
    }
    
    /// 셀 클릭에 따라 적절한 이벤트를 처리합니다.
    private func handleCellSelection(title: String) {
        switch title {
        case "프로필 사진 설정":
            break
        case "닉네임 설정":
            break
        case "이용약관":
            navigateToTermsOfService(title: title)
        case "개인정보 처리방침":
            navigateToPrivacyPolicy(title: title)
        case "로그아웃":
            presentSignOutConfirmationPopup(title: title)
        case "회원탈퇴":
            navigateToWithdrawAccount()
        default:
            break
        }
    }
    
}

extension MyPageViewController: UITableViewDelegate {
    /// 섹션의 타이틀을 설정합니다.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        var config = UIListContentConfiguration.groupedHeader()
        config.text = sectionTitles[section]
        config.textProperties.font = .gMarketSans(size: 11, family: .medium)
        config.textProperties.color = .tertiaryTextColor
        headerView.contentConfiguration = config
        return headerView
    }
}

extension MyPageViewController: UITableViewDataSource {
    /// 커스텀 셀을 적용합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingCell.ID,
            for: indexPath
        ) as? SettingCell
        else { return UITableViewCell() }
        let title = items[indexPath.section][indexPath.row]
        cell.configure(title: title)
        return cell
    }
    
    /// 섹션의 수를 지정합니다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    /// 섹션의 행 수를 지정합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
}

extension MyPageViewController {
    /// 개인정보 처리방침 화면으로 이동합니다.
    private func navigateToPrivacyPolicy(title: String) {
        let privacyPolicyViewController = PrivacyPolicyViewController()
        privacyPolicyViewController.title = title
        privacyPolicyViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
    }
    
    /// 이용약관 화면으로 이동합니다.
    private func navigateToTermsOfService(title: String) {
        let termsOfServiceViewController = TermsOfServiceViewController()
        termsOfServiceViewController.title = title
        termsOfServiceViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(termsOfServiceViewController, animated: true)
    }
    
    /// 회원탈퇴 화면으로 이동합니다.
    private func navigateToWithdrawAccount() {
        let authRepository = AuthRepository(networkManaer: AuthNetworkManager.shared)
        let authUseCase = AuthUseCase(repository: authRepository)
        let withdrawalViewModel = WithdrawalViewModel(useCase: authUseCase)
        let withdrawalViewController = WithdrawalViewController(viewModel: withdrawalViewModel)
        withdrawalViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(withdrawalViewController, animated: true)
    }
    
    /// 루트 뷰 컨트롤러를 로그인 화면으로 전환합니다.
    private func navigateToLoginScreen() {
        guard let scene = self.view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else { return }
        sceneDelegate.resetToLoginScreen()
    }
}

extension MyPageViewController {
    /// 로그아웃 팝업을 표시합니다.
    private func presentSignOutConfirmationPopup(title: String) {
        let popupViewController = PopupViewController(
            title: title,
            subtitle: "로그인 화면으로 이동할게요",
            mainButtonStyle: .init(title: "확인", backgroundColor: .tossRedColor),
            subButtonStyle: .init(title: "취소", backgroundColor: .primaryBackgroundColor),
            blurEffect: .init(style: .systemUltraThinMaterialLight))
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.modalTransitionStyle = .crossDissolve
        popupViewController.onMainAction = { [weak self] in
            self?.signOutButtonRelay.accept(())
        }
        self.present(popupViewController, animated: true)
    }
    
    /// 로그아웃 팝업 화면의 로딩 인디케이터 상태를 업데이트합니다.
    private func updateSignOutPopupLoadingState(isLoading: Bool) {
        guard let popupViewController = self.presentedViewController as? PopupViewController else{ return }
        popupViewController.updateActivityIndicatorState(isLoading)
    }
    
    /// 로그아웃 팝업 화면을 닫고 로그인 화면으로 전환합니다.
    private func dismissPopupAndNavigateToLogin() {
        guard let popupViewController = self.presentedViewController as? PopupViewController else { return }
        popupViewController.dismiss(animated: true) { [weak self] in
            self?.navigateToLoginScreen()
        }
    }
}
