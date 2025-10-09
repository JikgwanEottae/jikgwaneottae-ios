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
    private var dataSource: UICollectionViewDiffableDataSource<Section, DiaryTest>!
    private enum Section: CaseIterable { case main }
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = diaryHomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        configureNavigationBarItem()
        setupCollectionViewDataSource()
        applySnapshot(with: makeDummyData())
        bindCollectionView()
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: diaryHomeView.titleLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(plusButtonTapped)
        )
    }
    
    /// 컬렉션뷰 데이터 소스를 설정합니다.
    private func setupCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, DiaryTest>(
            collectionView: diaryHomeView.collectionView,
            cellProvider: { collectionView, indexPath, game in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiaryCollectionViewCell.ID,
                    for: indexPath
                ) as? DiaryCollectionViewCell else { return UICollectionViewCell() }
                cell.configure()
                return cell
            }
        )
    }
    
    /// 직관 일기 컬렉션 뷰를 뷰 컨트롤러와 바인딩합니다.
    /// 셀 아이템 클릭 시 직관 일기 상세화면으로 이동합니다.
    private func bindCollectionView() {
        diaryHomeView.collectionView.rx.itemSelected
            .compactMap { [weak self] indexPath in
                return self?.dataSource.itemIdentifier(for: indexPath)
            }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let diaryDetailViewController = DiaryDetailViewController()
                diaryDetailViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    /// 스냅샷을 생성하고 적용합니다.
    private func applySnapshot(with items: [DiaryTest]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DiaryTest>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// 임시 더미 데이터 생성
    private func makeDummyData() -> [DiaryTest] {
        return (1...19).map { DiaryTest(id: $0) }
    }
}

extension DiaryHomeViewController {
    @objc private func plusButtonTapped() {
        naviagateToGameDateSelectionViewController()
    }
}

extension DiaryHomeViewController {
    /// 경기 날짜 선택 화면으로 네비게이션 푸시합니다.
    private func naviagateToGameDateSelectionViewController() {
        let KBOGameRepository = KBOGameRepository(networkManager: KBOGameNetworkManager.shared)
        let KBOGameUseCase = KBOGameUseCase(repository: KBOGameRepository)
        let diaryGameDateSelectionViewModel = DiaryGameDateSelectionViewModel(useCase: KBOGameUseCase)
        let diaryGameDateSelectionViewController = DiaryGameDateSelectionViewController(viewModel: diaryGameDateSelectionViewModel)
        diaryGameDateSelectionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryGameDateSelectionViewController, animated: true)
    }
}
