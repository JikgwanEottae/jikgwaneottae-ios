//
//  HomeViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import RxSwift
import RxCocoa

enum HomeSection: String, CaseIterable, Hashable {
    case stats
    case todayGames
    case todayFortune
}

enum HomeItem: Hashable {
    case stats(DiaryStats)
    case todayGames(KBOGame)
    case todayFortune
}

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private let viewModel: HomeViewModel
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    private let viewDidAppearRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        configureNaviBarButtonItem()
        setupDatasource()
        applySnapshot()
        bindCollectionView()
        bindViewModel()
        viewDidAppearRelay.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(UserDefaultsManager.shared.nickname)
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNaviBarButtonItem() {
        let leftBarButtonItem = UIBarButtonItem(customView: homeView.titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    /// 스냅샷을 적용합니다.
    private func applySnapshot() {
        let snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    /// 스냅샷을 업데이트합니다.
    private func updateSnapshot(diaryStats: DiaryStats, games: [KBOGame]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.stats, .todayGames, .todayFortune])
        snapshot.appendItems([.stats(diaryStats)], toSection: .stats)
        let gameItems = games.map { HomeItem.todayGames($0) }
        snapshot.appendItems(gameItems, toSection: .todayGames)
        snapshot.appendItems([.todayFortune], toSection: .todayFortune)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// 컬렉션 뷰와 바인드합니다.
    private func bindCollectionView() {
        homeView.collectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.dataSource.itemIdentifier(for: indexPath)
                switch item {
                case .todayFortune:
                    let todayFortuneRepository = TodayFortuneRepository(networkManager: TodayFortuneNetworkManager.shared)
                    let todatFortuneUseCase = TodayFortuneUseCase(repository: todayFortuneRepository)
                    let todayFortuneViewModel = TodayFortuneViewModel(useCase: todatFortuneUseCase)
                    let todayFortuneViewController = TodayFortuneViewController(viewModel: todayFortuneViewModel)
                    todayFortuneViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(todayFortuneViewController, animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    /// 뷰 모델과 바인드합니다.
    private func bindViewModel() {
        let input = HomeViewModel.Input(viewDidAppear: viewDidAppearRelay)
        let output = viewModel.transform(input: input)
        // 모든 데이터가 준비되면 한 번에 스냅샷 구성
        Observable.combineLatest(output.diaryStats, output.todayGames)
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                let (diaryStats, games) = data
                owner.updateSnapshot(diaryStats: diaryStats, games: games)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    /// 컬렉션 뷰의 Diffable DataSource를 설정합니다.
    private func setupDatasource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>(
            collectionView: homeView.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .stats(let diaryStats):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: StatsCell.ID,
                        for: indexPath
                    ) as? StatsCell else { return UICollectionViewCell() }
                    cell.configure(stats: diaryStats)
                    return cell
                case .todayGames(let game):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TodayGameCell.ID,
                        for: indexPath
                    ) as? TodayGameCell else { return UICollectionViewCell() }
                    cell.configure(game: game)
                    return cell
                case .todayFortune:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TodayFortuneCell.ID,
                        for: indexPath
                    ) as? TodayFortuneCell else { return UICollectionViewCell() }
                    return cell
                }
            }
        )
    }
}
