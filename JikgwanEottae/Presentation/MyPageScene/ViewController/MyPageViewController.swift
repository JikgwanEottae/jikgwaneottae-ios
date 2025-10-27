//
//  MyPageViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/7/25.
//

import PhotosUI
import UIKit

import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    weak var delegate: SignOutDelegate?
    private let profileImageDataRelay = PublishRelay<(Bool, Data?)>()
    private let signOutButtonRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let sectionTitles = ["내 정보", "기타"]
    private let items = [
        ["닉네임 설정", "응원팀 설정"],
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
        profileEditButtonTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateProfileNickname()
        updateProfileImage()
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
            signOutButtonTapped: signOutButtonRelay.asObservable(),
            profileImageData: profileImageDataRelay.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.isLoading
            .drive(myPageView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        output.signOutSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.handleSignOutComplete()
            })
            .disposed(by: disposeBag)
        
        output.updateProfileImageSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.updateProfileImage()
            })
            .disposed(by: disposeBag)
        
        output
            .updateProfileImagefailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                owner.showAlert(
                    title: "업로드 실패",
                    message: "더 작은 이미지를 선택해주세요",
                    doneTitle: "확인",
                    doneStyle: .default
                )
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
        case "닉네임 설정":
            navigateToProfileNicknameEdit()
        case "응원팀 설정":
            navigateToFavoriteTeamEdit()
        case "이용약관":
            navigateToTermsOfService(title: title)
        case "개인정보 처리방침":
            navigateToPrivacyPolicy(title: title)
        case "로그아웃":
            presentSignOutConfirmationPopup(title: title)
        case "회원탈퇴":
            navigateToWithdrawAccount(title: title)
        default:
            break
        }
    }
    
    /// 프로필 이미지 편집 버튼 클릭 이벤트를 처리합니다.
    private func profileEditButtonTapped() {
        myPageView.profileEditButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.showProfileImageActionSheet()
            }
            .disposed(by: disposeBag)
    }
    
    /// 닉네임을 업데이트합니다.
    public func updateProfileNickname() {
        self.myPageView.updateProfileNickname()
    }
    
    /// 프로필 이미지를 업데이트 합니다.
    public func updateProfileImage() {
        self.myPageView.updateProfileImage()
    }
}

extension MyPageViewController {
    /// 닉네임 설정 화면으로 이동합니다.
    private func navigateToProfileNicknameEdit() {
        let authRepository = AuthRepository(networkManaer: AuthNetworkManager.shared)
        let authUseCase = AuthUseCase(repository: authRepository)
        let nicknameEditViewModel = NicknameEditViewModel(useCase: authUseCase)
        let nicknameEditViewController = NicknameEditViewController(viewModel: nicknameEditViewModel, isInitialEdit: false)
        nicknameEditViewController.onNicknameUpdated = { [weak self] in
            self?.updateProfileNickname()
        }
        nicknameEditViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nicknameEditViewController, animated: true)
    }
    
    /// 응원구단 설정 화면으로 이동합니다.
    private func navigateToFavoriteTeamEdit() {
        let repository = AuthRepository(networkManaer: AuthNetworkManager.shared)
        let useCase = AuthUseCase(repository: repository)
        let viewModel = FavoriteTeamEditViewModel(useCase: useCase)
        let viewController = FavoriteTeamEditViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
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
    private func navigateToWithdrawAccount(title: String) {
        let authRepository = AuthRepository(networkManaer: AuthNetworkManager.shared)
        let authUseCase = AuthUseCase(repository: authRepository)
        let withdrawalViewModel = WithdrawalViewModel(useCase: authUseCase)
        let withdrawalViewController = WithdrawalViewController(viewModel: withdrawalViewModel)
        withdrawalViewController.delegate = self
        withdrawalViewController.title = title
        withdrawalViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(withdrawalViewController, animated: true)
    }
    
    /// 게스트 모드로 전환합니다
    private func handleSignOutComplete() {
        self.delegate?.signOutDidComplete()
    }
}

extension MyPageViewController {
    /// 로그아웃 팝업을 표시합니다.
    private func presentSignOutConfirmationPopup(title: String) {
        self.showAlert(
            title: "알림",
            message: "정말 로그아웃할까요?",
            doneTitle: title,
            doneStyle: .destructive,
            cancelTitle: "닫기",
            cancelStyle: .cancel,
            doneCompletion: { [weak self] in
                self?.signOutButtonRelay.accept(())
            }
        )
    }
}

extension MyPageViewController {
    private func showProfileImageActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let selectFromAlbumAction = UIAlertAction(
            title: "앨범에서 선택",
            style: .default
        ) { [weak self] _ in
            self?.presentPhotoPicker()
        }
        alertController.addAction(selectFromAlbumAction)
        
        let deletePhotoAction = UIAlertAction(
            title: "프로필 사진 삭제",
            style: .destructive
        ) { [weak self] _ in
            self?.profileImageDataRelay.accept((true, nil))
        }
        alertController.addAction(deletePhotoAction)
        let cancelAction = UIAlertAction(
            title: "닫기",
            style: .cancel
        )
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    /// 프로필 사진을 선택하기 위한 포토 피커를 표시합니다.
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension MyPageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else { return }
                let imageData = image.jpegData(compressionQuality: 0.8)
                self?.profileImageDataRelay.accept((false, imageData))
            }
        }
    }
}

extension MyPageViewController: UITableViewDelegate {
    /// 섹션의 타이틀을 설정합니다.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        var config = UIListContentConfiguration.groupedHeader()
        config.text = sectionTitles[section]
        config.textProperties.font = UIFont.pretendard(size: 11, family: .medium)
        config.textProperties.color = UIColor.Text.tertiaryColor
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

extension MyPageViewController: SignOutDelegate {
    func signOutDidComplete() {
        self.handleSignOutComplete()
    }
}
