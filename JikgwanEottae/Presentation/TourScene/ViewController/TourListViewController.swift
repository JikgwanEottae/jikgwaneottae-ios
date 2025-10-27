//
//  TourListViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/25/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 관광 데이터를 리스트로 보여주기 위한 뷰 컨트롤러입니다.

final class TourListViewController: UIViewController {
    private let tourListView = TourListView()
    private let tourPlaces: [TourPlace]
    private let disposeBag = DisposeBag()
    
    init(tourPlaces: [TourPlace]) {
        self.tourPlaces = tourPlaces
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = tourListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        bindTableView()
    }
    
    /// 관광 데이터를 테이블 뷰에 바인드합니다.
    private func bindTableView() {
        // 관광 데이터를 테이블 뷰에 전달합니다.
        Observable.just(tourPlaces)
            .bind(to: tourListView.tableView.rx.items(
                cellIdentifier: TourPlaceCell.ID,
                cellType: TourPlaceCell.self)
            ) { row, tourPlace, cell in
                cell.configure(with: tourPlace)
            }
            .disposed(by: disposeBag)
        
        // 관광 데이터가 클릭됬을 때 이벤트입니다.
        tourListView.tableView.rx.modelSelected(TourPlace.self)
            .withUnretained(self)
            .subscribe(onNext: { owner, tourPlace in
                owner.presentTourPlaceDetail(contentID: tourPlace.id)
            })
            .disposed(by: disposeBag)
    }
    
    /// 관광 장소 상세보기 화면으로 전환합니다.
    private func presentTourPlaceDetail(contentID: String) {
        let repository = TourRepository(manager: TourNetworkManager.shared)
        let useCase = TourUseCase(repository: repository)
        let viewModel = TourPlaceDetailViewModel(useCase: useCase, contentID: contentID)
        let viewController = TourPlaceDetailViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

