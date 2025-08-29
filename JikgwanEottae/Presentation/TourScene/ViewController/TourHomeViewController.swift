//
//  TourHomeViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/29/25.
//

import UIKit

import RxSwift
import RxCocoa

final class TourHomeViewController: UIViewController {
    private let tourHomeView = TourHomeView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = tourHomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        configureNaviBarButtonItem()
        bindCollectionView()
    }
    
    /// 네비게이션 왼쪽 바 버튼 아이템에 타이틀을 설정합니다.
    private func configureNaviBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: tourHomeView.leftBarButtonTitleLabel)
    }
    
    /// 컬렉션 뷰를 바인드합니다.
    private func bindCollectionView() {
        Driver.just(KBOTeam.allCases)
            .drive(tourHomeView.collectionView.rx.items(
                cellIdentifier: TeamSelectionCell.ID,
                cellType: TeamSelectionCell.self
            )) { row, element, cell in
                cell.configure(team: element)
            }
            .disposed(by: disposeBag)
        
        tourHomeView.collectionView.rx.modelSelected(KBOTeam.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedTeam in
                owner.navigateToTourMap(with: selectedTeam)
            })
            .disposed(by: disposeBag)
    }
}

extension TourHomeViewController {
    /// 구단별 관광지 찾기 화면으로 이동합니다.
    private func navigateToTourMap(with selectedTeam: KBOTeam) {
        let tourRepository = TourRepository(manager: TourNetworkManager.shared)
        let tourUseCase = TourUseCase(repository: tourRepository)
        let tourViewModel = TourMapViewModel(useCase: tourUseCase, selectedTeam: selectedTeam)
        let tourMapViewController = TourMapViewController(viewModel: tourViewModel)
        tourMapViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(tourMapViewController, animated: true)
    }
}
