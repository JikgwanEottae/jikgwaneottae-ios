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
    case tour
    
    var title: String {
        switch self {
        case .tour:
            return "구단별 관광지 찾기"
        }
    }
}

enum HomeItem: Hashable {
    case tourItem(teamName: String)
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
        // 구단별 관광지 조회 섹션입니다.
        snapshot.appendSections([.tour])
        let tourItems = KBOTeam.allCases.map { HomeItem.tourItem(teamName: $0.rawValue) }
        // 구단별 관광지 조회 섹션에 아이템을 추가합니다.
        snapshot.appendItems(tourItems, toSection: .tour)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func bindCollectionView() {
        homeView.collectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let item = self?.dataSource.itemIdentifier(for: indexPath)
                switch item {
                case .tourItem(let teamName):
                    let tourViewController = TourViewController(team: KBOTeam(rawValue: teamName)!)
                    tourViewController.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(tourViewController, animated: true)
                case nil:
                    break
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
                case .tourItem(let teamName):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TeamTourCell.ID,
                        for: indexPath) as? TeamTourCell else {
                        return UICollectionViewCell()
                    }
                    cell.configure(teamName: teamName)
                    return cell
                }
            }
        )
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionTitleHeaderView>(
            elementKind: SectionTitleHeaderView.elementKind) { [weak self] supplementaryView, elementKind, indexPath in
                guard let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] else { return }
                supplementaryView.configure(title: section.title)
            }
        
        let seperatorRegistration = UICollectionView.SupplementaryRegistration<SectionSeparatorView>(
            elementKind: SectionSeparatorView.elementKind
        ) { _, _, _ in }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
            } else {
                return collectionView.dequeueConfiguredReusableSupplementary(using: seperatorRegistration, for: indexPath)
            }
        }
    }
}
