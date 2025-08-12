//
//  RecordDateGameSelectionViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/26/25.
//

import UIKit

import RxCocoa
import RxSwift

final class DiaryGameDateSelectionViewController: UIViewController {
    private let diaryGameDateSelectionView = DiaryGameDateSelectionView()
    private let viewModel: DiaryGameDateSelectionViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, KBOGame>!
    private enum Section: CaseIterable { case main }
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryGameDateSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryGameDateSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        configureDataSource()
        bindViewModel()
        bindCollectionView()
    }
    
    private func bindViewModel() {
        let input = DiaryGameDateSelectionViewModel.Input(
            selectedDate: diaryGameDateSelectionView.datePicker.rx.date.asDriver()
        )
        
        let output = viewModel.transform(input: input)
        // 날짜에 맞는 경기 리스트 바인딩
        output.dailyGames
            .drive(onNext: { [weak self] games in
                if games.isEmpty {
                    self?.diaryGameDateSelectionView.collectionView.setEmptyView(
                        image: UIImage(systemName: "exclamationmark.circle"),
                        message: "경기 일정이 없어요"
                    )
                } else {
                    self?.diaryGameDateSelectionView.collectionView.restore()
                }
                self?.updateSnapshot(games: games)
            })
            .disposed(by: disposeBag)
        
        // 로딩 인디케이터 바인딩
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                self?.diaryGameDateSelectionView.interactionBlocker.isHidden = !isLoading
                if isLoading {
                    self?.diaryGameDateSelectionView.activityIndicator.startAnimating()
                } else {
                    self?.diaryGameDateSelectionView.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        // 선택한 경기 아이템을 제공받고, 직관 일기 생성 화면으로 전환
        diaryGameDateSelectionView.collectionView.rx
            .itemSelected
            .compactMap { [weak self] indexPath in
                return self?.dataSource.itemIdentifier(for: indexPath)
            }
            .subscribe(onNext: { [weak self] selectedKBOGame in
                let diaryRepository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
                let diaryUseCase = DiaryUseCase(repository: diaryRepository)
                let diaryEditViewModel = DiaryEditViewModel(usecase: diaryUseCase, mode: .create(game: selectedKBOGame))
                let diaryEditViewController = DiaryEditViewController(viewModel: diaryEditViewModel)
                self?.navigationController?.pushViewController(diaryEditViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, KBOGame>(
            collectionView: diaryGameDateSelectionView.collectionView,
            cellProvider: { collectionView, indexPath, game in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: KBOGameCollectionViewCell.ID,
                    for: indexPath
                ) as! KBOGameCollectionViewCell
                cell.configure(game: game)
                return cell
            }
        )
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, KBOGame>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateSnapshot(games: [KBOGame]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, KBOGame>()
        snapshot.appendSections([.main])
        snapshot.appendItems(games, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
