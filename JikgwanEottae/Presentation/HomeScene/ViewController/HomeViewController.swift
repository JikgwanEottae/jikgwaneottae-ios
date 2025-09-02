//
//  HomeViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import RxSwift
import RxCocoa

enum HomeSection: Int, CaseIterable, Hashable {
    case stats
    case todayFortune
}

enum HomeItem: Hashable {
    case stats
    case todayFortune
}

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeItem>!
    private let disposeBag = DisposeBag()
    
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
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNaviBarButtonItem() {
        let leftBarButtonItem = UIBarButtonItem(customView: homeView.titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    /// 섹션별 스냅샷을 적용합니다.
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.stats, .todayFortune])
        snapshot.appendItems([.stats], toSection: .stats)
        snapshot.appendItems([.todayFortune], toSection: .todayFortune)
//        // 구단별 관광지 조회 섹션입니다.
//        snapshot.appendSections([.tour])
//        let tourItems = KBOTeam.allCases.map { HomeItem.tourItem(team: $0) }
//        // 구단별 관광지 조회 섹션에 아이템을 추가합니다.
//        snapshot.appendItems(tourItems, toSection: .tour)
//        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bindCollectionView() {
        homeView.collectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.dataSource.itemIdentifier(for: indexPath)
                switch item {
                case .todayFortune:
                    let todayFortuneViewModel = TodayFortuneViewModel()
                    let todayFortuneViewController = TodayFortuneViewController(viewModel: todayFortuneViewModel)
                    todayFortuneViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(todayFortuneViewController, animated: true)
                default:
                    break
//                case .tourItem(let selectedTeam):
//                    let tourRepository = TourRepository(manager: TourNetworkManager.shared)
//                    let tourUseCase = TourUseCase(repository: tourRepository)
//                    let tourViewModel = TourMapViewModel(useCase: tourUseCase, selectedTeam: selectedTeam)
//                    let tourViewController = TourMapViewController(viewModel: tourViewModel)
//                    tourViewController.hidesBottomBarWhenPushed = true
//                    self.navigationController?.pushViewController(tourViewController, animated: true)
//                default:
//                    break
                }
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
                case .stats:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: StatsCell.ID, for: indexPath
                    ) as? StatsCell else { return UICollectionViewCell() }
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
        
//        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionTitleHeaderView>(
//            elementKind: SectionTitleHeaderView.elementKind) { [weak self] supplementaryView, elementKind, indexPath in
//                guard let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] else { return }
//                supplementaryView.configure(title: section.title)
//            }
//        
//        let seperatorRegistration = UICollectionView.SupplementaryRegistration<SectionSeparatorView>(
//            elementKind: SectionSeparatorView.elementKind
//        ) { _, _, _ in }
//        
//        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
//            if kind == UICollectionView.elementKindSectionHeader {
//                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
//            } else {
//                return collectionView.dequeueConfiguredReusableSupplementary(using: seperatorRegistration, for: indexPath)
//            }
//        }
    }
}
