//
//  TourViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/24/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - 구단별 관광지 찾기를 담당하는 뷰 모델입니다.

final class TourViewModel: ViewModelType {
    private let useCase: TourUseCaseProtocol
    private let disposeBag = DisposeBag()
    private var currentPage: Int = 1 // 현재 페이지
    private var currentItemCount: Int = 0 // 현재 누적 아이템 수
    private var totalItemCount: Int = 0 // 전체 아이템 수
    private var currentTourPlace: [TourPlace] = [] // 현재 누적 관광 장소
    
    struct Input {
        let tourTypeSelected: BehaviorRelay<TourType>
        let mapCenterChanged: BehaviorRelay<Coordinate>
    }
    
    struct Output {
        
    }
    
    init(useCase: TourUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        Observable.combineLatest(
            input.tourTypeSelected.asObservable(),
            input.mapCenterChanged.asObservable()
        )
        .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] tourType, coordinate in
            
        })
        .disposed(by: disposeBag)
        
        
        return Output()
    }
    
    
}

extension TourViewModel {
    private func fetch(contentTypeId: Int, coordinate: Coordinate) {
        self.useCase.fetchTourPlacesByLocation(
            pageNo: 1,
            longitude: coordinate.longitude,
            latitude: coordinate.latitude,
            radius: 3000,
            contentTypeId: contentTypeId
        )
        .subscribe(onSuccess: { tourPlacePage in
            print(tourPlacePage)
        })
        .disposed(by: disposeBag)
    }
}
