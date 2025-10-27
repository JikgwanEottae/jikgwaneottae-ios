//
//  TourBallparkSelectionViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 구단 주변 인기 연관 관광지 TOP 50을 조회하기 위한 구장 선택 뷰 컨트롤러입니다.

final class TourBallparkSelectionViewController: UIViewController {
    private let tourBallparkSelectionView = TourBallparkSelectionView()
    private let viewModel: TourBallparkSelectionViewModel
    private let ballparks = Observable.just(KBOTeam.allCases)
    private let selectedTeamRelay = PublishRelay<KBOTeam>()
    private let disposeBag = DisposeBag()

    init(viewModel: TourBallparkSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = tourBallparkSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        bindTableView()
        bindViewModel()
    }
    
    private func bindTableView() {
        let tableView = tourBallparkSelectionView.ballparkTableView
        
        ballparks.bind(to: tableView.rx.items(
                cellIdentifier: BallparkSelectionCell.ID,
                cellType: BallparkSelectionCell.self)
            ) { row, team, cell in
            cell.configure(with: team)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(KBOTeam.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, team in
                owner.selectedTeamRelay.accept(team)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = TourBallparkSelectionViewModel.Input(
            team: selectedTeamRelay
        )
        let output = viewModel.transform(input: input)
        
        output.fetchSuccess
            .withUnretained(self)
            .subscribe(onNext: { owner, places in
                owner.navigateToNearbyTourPlaceScene(places)
            })
            .disposed(by: disposeBag)
        
        output.fetchFailure
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(tourBallparkSelectionView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension TourBallparkSelectionViewController {
    private func navigateToNearbyTourPlaceScene(_ places: NearbyTourPlace) {
        let viewModel = TourNearByPlaceViewModel(places: places)
        let viewController = TourNearByPlaceViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
