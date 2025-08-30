//
//  TourPlaceDetailViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/31/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 관광 장소 상세보기를 위한 뷰 모델입니다.

final class TourPlaceDetailViewModel: ViewModelType {
    private let useCase: TourUseCaseProtocol
    private let contentID: String
    private let isLoadingRelay  = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let tourPlaceDetail: Signal<TourPlace>
        let isLoading: Driver<Bool>
    }
    
    init(useCase: TourUseCaseProtocol, contentID: String) {
        self.useCase = useCase
        self.contentID = contentID
    }
    
    public func transform(input: Input) -> Output {
        let tourPlaceDetailRelay = PublishRelay<TourPlace>()
        input.viewDidLoad
            .withUnretained(self)
            .flatMapLatest { owner, _ -> Single<TourPlace> in
                owner.isLoadingRelay.accept(true)
                return owner.useCase.fetchTourPlaceCommonDetail(contentID: owner.contentID)
                    .map { $0.tourPlaces.first! }
            }
            .subscribe(onNext: { [weak self] tourPlace in
                tourPlaceDetailRelay.accept(tourPlace)
                self?.isLoadingRelay.accept(false)
            }, onError: { [weak self] error in
                self?.isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)

        return Output(
            tourPlaceDetail: tourPlaceDetailRelay.asSignal(),
            isLoading: isLoadingRelay.asDriver()
        )
    }
}
