//
//  FortuneTeamSelectionViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/10/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 오늘의 직관 운세를 확인하기 위한 응원 구단 선택 뷰 컨트롤러입니다.

final class FortuneTeamSelectionViewController: UIViewController {
    private let fortuneTeamSelectionView = FortuneTeamSelectionView()
    private let teams = Observable.just(Team.allCases)
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = fortuneTeamSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        bindTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fortuneTeamSelectionView.progressView.setProgress(0.3, animated: true)
        }
    }
    
    private func bindTableView() {
        let tableView = fortuneTeamSelectionView.teamTableView
        
        teams.bind(to: tableView.rx.items(
                cellIdentifier: TeamTableViewCell.ID,
                cellType: TeamTableViewCell.self)
            ) { row, team, cell in
                cell.configure(with: team.rawValue)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Team.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, team in
                owner.navigateToGenderSelection("\(team)")
            })
            .disposed(by: disposeBag)
    }
}

extension FortuneTeamSelectionViewController {
    private func navigateToGenderSelection(_ favoriteTeam: String) {
        let viewModel = FortuneGenderSelectionViewModel(favoriteTeam: favoriteTeam)
        let viewController = FortuneGenderSelectionViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}
