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
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedKBOGame in
                owner.handleGameSelection(selectedKBOGame)
            })
            .disposed(by: disposeBag)
    }
    
    /// 전반적인 데이터 소스를 설정합니다.
    private func configureDataSource() {
         setupCollectionViewDataSource()
         applyInitialSnapshot()
     }
    
    /// 컬렉션뷰 데이터 소스를 설정합니다.
    private func setupCollectionViewDataSource() {
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
    }
    
    /// 스냅샷의 초기 상태를 적용합니다.
    private func applyInitialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, KBOGame>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// 스냅샷을 업데이트합니다.
    private func updateSnapshot(games: [KBOGame]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, KBOGame>()
        snapshot.appendSections([.main])
        snapshot.appendItems(games, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    
    private func handleGameSelection(_ game: KBOGame) {
        guard isGamePlayCompleted(game) else {
            showGameNotAvailableAlert()
            return
        }
        navigateToDiaryCreation(with: game)
    }
    
    /// 진행 완료된 경기인지 체크합니다.
    private func isGamePlayCompleted(_ game: KBOGame) -> Bool {
        return game.status == "PLAYED"
    }
    
    /// 직관 일기 생성화면으로 이동합니다.
    private func navigateToDiaryCreation(with game: KBOGame) {
         let diaryCreationViewController = createDiaryCreationViewController(for: game)
         navigationController?.pushViewController(diaryCreationViewController, animated: true)
     }
    
    /// 직관 일기 생성화면을 생성합니다.
    private func createDiaryCreationViewController(for game: KBOGame) -> DiaryCreationViewController {
        let diaryRepository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
        let diaryUseCase = DiaryUseCase(repository: diaryRepository)
        let diaryCreationViewModel = DiaryCreationViewModel(useCase: diaryUseCase, selectedGame: game)
        return DiaryCreationViewController(viewModel: diaryCreationViewModel)
    }
    
    /// 직관 일기 기록 불가 알림창을 표시합니다.
    private func showGameNotAvailableAlert() {
        showAlert(
            title: "알림",
            message: "경기가 끝난 후에 기록할 수 있어요",
            doneTitle: "확인"
        )
    }
}
