//
//  TourPlaceDetailViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/29/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 관광 장소 상세보기를 위한 뷰 컨트롤러입니다.

final class TourPlaceDetailViewController: UIViewController {
    private let tourPlaceDetailView = TourPlaceDetailView()
    private let viewModel: TourPlaceDetailViewModel
    private let viewDidLoadTrigger = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: TourPlaceDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = tourPlaceDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewDidLoadTrigger.accept(())
    }
    
    private func bindViewModel() {
        let input = TourPlaceDetailViewModel.Input(viewDidLoad: viewDidLoadTrigger.asObservable())
        let output = viewModel.transform(input: input)
        output.tourPlaceDetail
            .withUnretained(self)
            .emit(onNext: { owner, tourPlace in
                owner.tourPlaceDetailView.configure(with: tourPlace)
            })
            .disposed(by: disposeBag)
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.tourPlaceDetailView.activityIndicator.startAnimating()
                } else {
                    self?.tourPlaceDetailView.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
    }
}
