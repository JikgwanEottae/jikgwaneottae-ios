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
        configureBackBarButtonItem()
        bindTableView()
        bindViewModel()
    }
    
    private func bindTableView() {
//        diaryGameDateSelectionView.tableView.rx.itemSelected
//            .withUnretained(self)
//            .subscribe(onNext: { owner, indexPath in
//
//                let recordDetailInputVC = RecordDetailInputViewController()
//                owner.navigationController?.pushViewController(recordDetailInputVC, animated: true)
//            })
//            .disposed(by: disposeBag)
        diaryGameDateSelectionView.tableView.rx
            .modelSelected(KBOGame.self)
            .subscribe(onNext: { game in
                print(game)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = DiaryGameDateSelectionViewModel.Input(
            selectedDate: diaryGameDateSelectionView.datePicker.rx.date
                .distinctUntilChanged()
                .asDriver(onErrorDriveWith: .empty())
        )
        
        let output = viewModel.transform(input: input)
        
        // 테이블 뷰와 바인드
        output.dailyGames
            .drive(diaryGameDateSelectionView.tableView.rx.items(
                cellIdentifier: KBOGameTableViewCell.ID,
                cellType: KBOGameTableViewCell.self)
            ) { row, games, cell in
                cell.configure(game: games)
            }
            .disposed(by: disposeBag)
        
        output.dailyGames
            .drive(onNext: { [weak self] games in
                if games.isEmpty {
                    self?.diaryGameDateSelectionView.tableView.setEmptyView(
                        image: UIImage(resource: .exclamation),
                        message: "경기 일정이 없거나 아직 경기 중이에요"
                    )
                } else {
                    self?.diaryGameDateSelectionView.tableView.restore()
                }
                let height = CGFloat(max(games.count * 110, 110))
                self?.diaryGameDateSelectionView.updateTableViewHeight(to: height)
            })
            .disposed(by: disposeBag)
        
        // 로딩 인디케이터 
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                self?.diaryGameDateSelectionView.interactionBlocker.isHidden = !isLoading
                isLoading
                ? self?.diaryGameDateSelectionView.activityIndicator.startAnimating()
                : self?.diaryGameDateSelectionView.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}
