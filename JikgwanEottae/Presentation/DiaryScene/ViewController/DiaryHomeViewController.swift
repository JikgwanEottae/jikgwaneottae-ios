//
//  DiaryHomeViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/25/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 직관 일기 홈을 담당하는 뷰 컨트롤러입니다.

final class DiaryHomeViewController: UIViewController {
    
    private let diaryHomeView = DiaryHomeView()
    private let viewModel: DiaryHomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<DiarySection, Diary>!
    private enum DiarySection: Hashable {
        case month(yearMonth: String)
    }
    private let selectedFilterRelay = BehaviorRelay(value: DiaryFilterType.all)
    private let refreshRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryHomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        configureNavigationBarItem()
        setupCollectionViewDataSource()
        setupAddTargets()
        bindNavigationButtons()
        bindCollectionView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 게스트 모드일 경우 스냅샷 초기화
        guard !AppState.shared.isGuestMode else {
            applySnapshot(with: [])
            return
        }
        // 일기 기록을 갱신해야할 경우
        guard !AppState.shared.needsDiaryRefresh else {
            refreshRelay.accept(())
            return
        }
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: diaryHomeView.titleLabel)
        self.navigationItem.rightBarButtonItems = [diaryHomeView.plusButton]
    }
    
    private func bindNavigationButtons() {
        diaryHomeView.plusButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                if AppState.shared.isGuestMode {
                    let repository = AuthRepository(networkManaer: AuthNetworkManager.shared)
                    let useCase = AuthUseCase(repository: repository)
                    let viewModel = SignInViewModel(useCase: useCase)
                    let viewController = SignInViewController(viewModel: viewModel)
                    viewController.delegate = self
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.configureBarAppearnace()
                    navigationController.modalPresentationStyle = .overFullScreen
                    owner.present(navigationController, animated: true)
                } else {
                    owner.naviagateToGameDateSelectionViewController()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = DiaryHomeViewModel.Input(
            selectedFilter: selectedFilterRelay
                .asObservable(),
            refreshTrigger: refreshRelay
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.diaries
            .drive(onNext: { [weak self] diaries in
                guard let self = self else { return }
                self.applySnapshot(with: diaries)
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(diaryHomeView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    /// 직관 일기 컬렉션 뷰를 뷰 컨트롤러와 바인딩합니다.
    /// 셀 아이템 클릭 시 직관 일기 상세화면으로 이동합니다.
    private func bindCollectionView() {
        diaryHomeView.collectionView.rx.itemSelected
            .compactMap { [weak self] indexPath in
                self?.dataSource.itemIdentifier(for: indexPath)
            }
            .subscribe(onNext: { [weak self] diary in
                guard let self = self else { return }
                let repository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
                let useCase = DiaryUseCase(repository: repository)
                let viewModel = DiaryDetailViewModel(
                    useCase: useCase,
                    diary: diary
                )
                let viewController = DiaryDetailViewController(viewModel: viewModel)
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension DiaryHomeViewController {
    private func groupDiariesByYearMonth(_ diaries: [Diary]) -> [(key: String, value: [Diary])] {
        let grouped = Dictionary(grouping: diaries) { diary -> String in
            return String(diary.gameDate.prefix(7))
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    /// 컬렉션뷰 데이터 소스를 설정합니다.
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<DiarySection, Diary>(
            collectionView: diaryHomeView.collectionView,
            cellProvider: { collectionView, indexPath, diary in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiaryCollectionViewCell.ID,
                    for: indexPath
                ) as? DiaryCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: diary)
                return cell
            }
        )
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let self = self else { return nil }
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DiarySectionHeaderView.ID,
                for: indexPath
            ) as? DiarySectionHeaderView else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if case .month(yearMonth: let yearMonth) = section {
                header.configure(with: yearMonth)
            }
            return header
        }
    }
    
    /// 스냅샷을 생성하고 적용합니다.
    private func applySnapshot(with items: [Diary]) {
        var snapshot = NSDiffableDataSourceSnapshot<DiarySection, Diary>()
        let grouped = groupDiariesByYearMonth(items)
        
        grouped.forEach { (yearMonth, diaries) in
            let section = DiarySection.month(yearMonth: yearMonth)
            snapshot.appendSections([section])
            snapshot.appendItems(diaries, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
        if items.isEmpty {
            diaryHomeView.collectionView.setEmptyView(
                image: UIImage(systemName: "book.pages"),
                message: "표시할 일기가 없어요"
            )
        } else {
            diaryHomeView.collectionView.restore()
        }
    }
}

extension DiaryHomeViewController {
    /// 경기 날짜 선택 화면으로 네비게이션 푸시합니다.
    private func naviagateToGameDateSelectionViewController() {
        let repository = KBOGameRepository(networkManager: KBOGameNetworkManager.shared)
        let useCase = KBOGameUseCase(repository: repository)
        let viewModel = DiaryGameDateSelectionViewModel(useCase: useCase)
        let viewController = DiaryGameDateSelectionViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DiaryHomeViewController: SignInDelegate {
    public func signInDidComplete() {
        naviagateToGameDateSelectionViewController()
    }
}

extension DiaryHomeViewController {
    private func setupAddTargets() {
        [diaryHomeView.allButton,
         diaryHomeView.winButton,
         diaryHomeView.lossButton,
         diaryHomeView.drawButton
        ].forEach {
            $0.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc
    private func filterTapped(_ sender: UIButton) {
        diaryHomeView.selectFilterButton(sender)
        switch sender {
        case diaryHomeView.allButton: selectedFilterRelay.accept(.all)
        case diaryHomeView.winButton: selectedFilterRelay.accept(.win)
        case diaryHomeView.lossButton: selectedFilterRelay.accept(.loss)
        case diaryHomeView.drawButton: selectedFilterRelay.accept(.draw)
        default: break
        }
    }
}
