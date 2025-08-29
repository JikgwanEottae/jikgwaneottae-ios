//
//  TourMapViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/24/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - 구단별 관광지 찾기를 담당하는 뷰 모델입니다.

final class TourMapViewModel: ViewModelType {
    private let useCase: TourUseCaseProtocol
    private let disposeBag = DisposeBag()
    private let selectedTeam: KBOTeam
    // 페이징 상태 관리
    private var currentPage: Int = 1
    private var hasMoreData: Bool = true
    // 데이터 상태 관리
    private var currentTourPlaces: [TourPlace] = []
    private var currentTourType = TourType.restaurant
    // rx 상태 관리
    private let currentCoordinate: BehaviorRelay<Coordinate>
    private let isShowMoreMode = BehaviorRelay(value: false) // true: "더보기", false: "이 지역 검색하기"
    private let tourPlaceRelay = PublishRelay<[TourPlace]>()
    private let hasMoreDataRelay = BehaviorRelay<Bool>(value: true)
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    struct Input {
        let tourTypeSelected: PublishSubject<TourType>
        let mapCenterChanged: PublishRelay<Coordinate>
        let centerButtonTapped: Observable<Void>
        let resetCoordinateButtonTapped: Observable<Void>
    }
    
    struct Output {
        let naviTitle: Driver<String>
        let initialCoordinate: Driver<Coordinate>
        let resetCoordinate: Observable<Coordinate>
        let centerButtonState: Driver<Bool>
        let tourPlaces: Observable<[TourPlace]>
        let isLoading: Driver<Bool>
        let hasMoreData: Observable<Bool>
    }
    
    init(useCase: TourUseCaseProtocol, selectedTeam: KBOTeam) {
        self.useCase = useCase
        self.selectedTeam = selectedTeam
        self.currentCoordinate = BehaviorRelay<Coordinate>(value: selectedTeam.coordinate)
    }
    
    public func transform(input: Input) -> Output {
        let initialCoordinate = selectedTeam.coordinate
        
        input.tourTypeSelected
            .withUnretained(self)
            .subscribe(onNext: { owner, tourType in
                owner.handleTourTypeSelection(tourType)
            })
            .disposed(by: disposeBag)
        
        input.mapCenterChanged
            .withUnretained(self)
            .subscribe(onNext: { owner, coordinate in
                owner.handleMapCenterChange(coordinate)
            })
            .disposed(by: disposeBag)
        
        input.centerButtonTapped
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.handleCenterButtonTap()
            })
            .disposed(by: disposeBag)
        
        // 원위치 버튼이 클릭됬을 때
        let resetCoordinate = input.resetCoordinateButtonTapped
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.currentCoordinate.accept(initialCoordinate)
            })
            .map { _, _ in initialCoordinate }
        
        return Output(
            naviTitle: Driver.just(selectedTeam.ballpark),
            initialCoordinate: Driver.just(initialCoordinate),
            resetCoordinate: resetCoordinate,
            centerButtonState: isShowMoreMode.asDriver(),
            tourPlaces: tourPlaceRelay.asObservable(),
            isLoading: isLoadingRelay.asDriver(),
            hasMoreData: hasMoreDataRelay.asObservable(),
        )
    }
}

extension TourMapViewModel {
    /// 페이징 상태를 초기화합니다.
    private func resetPagingState() {
        currentPage = 1
        hasMoreData = true
        currentTourPlaces.removeAll()
    }
    
    /// 관광 타입 선택 처리 핸들러입니다.
    private func handleTourTypeSelection(_ tourType: TourType) {
        resetPagingState()
        currentTourType = tourType
        isShowMoreMode.accept(true)
        fetchTourPlaces(
            tourType: currentTourType,
            coordinate: currentCoordinate.value,
            isAppendMode: false
        )
    }
    
    /// 지도 중심 좌표 변경 핸들러입니다.
    private func handleMapCenterChange(_ coordinate: Coordinate) {
        currentCoordinate.accept(coordinate)
        isShowMoreMode.accept(false)
    }
    
    /// 중앙 버튼 클릭 처리 핸들러입니다.
    private func handleCenterButtonTap() {
        if isShowMoreMode.value {
            if hasMoreData && !isLoadingRelay.value {
                fetchTourPlaces(
                    tourType: currentTourType,
                    coordinate: currentCoordinate.value,
                    isAppendMode: true
                )
            }
            if !hasMoreData {
                hasMoreDataRelay.accept(hasMoreData)
            }
        } else {
            resetPagingState()
            isShowMoreMode.accept(true)
            fetchTourPlaces(
                tourType: currentTourType,
                coordinate: currentCoordinate.value,
                isAppendMode: false
            )
        }
    }
    /// 위치기반 관광지 데이터 응답 처리입니다.
    private func handleTourPlaceResponse(
        _ tourPlacePage: TourPlacePage,
        isAppendMode: Bool
    ) {
        isLoadingRelay.accept(false)
        // 페이징 상태 업데이트
        currentPage = tourPlacePage.pageNo + 1
        // 더 가져올 데이터가 있는지 확인
        let currentItemCount = currentTourPlaces.count + tourPlacePage.numOfRows
        hasMoreData = currentItemCount < tourPlacePage.totalCount
        if isAppendMode {
            currentTourPlaces.append(contentsOf: tourPlacePage.tourPlaces)
        } else {
            currentTourPlaces = tourPlacePage.tourPlaces
        }
        // 패치한 관광지 데이터를 방출
        tourPlaceRelay.accept(currentTourPlaces)
        print("페이지 번호: \(tourPlacePage.pageNo)")
        print("받아온 데이터 수: \(tourPlacePage.numOfRows)")
        print("서버에 있는 전체 데이터 수: \(tourPlacePage.totalCount)")
        print("---------------------------------------")
        print("저장되어 있는 데이터: \(currentTourPlaces.count)")
        print("---------------------------------------")
        dump(tourPlacePage.tourPlaces)
    }
    
    /// 위치기반 관광지 데이터 에러 처리입니다.
    private func handleTourPlaceError(_ error: Error) {
        isLoadingRelay.accept(false)
        print("관광지 데이터 로드 실패: \(error.localizedDescription)")
    }
    
    /// 위치기반 관광지 데이터를 패치합니다.
    private func fetchTourPlaces(
        tourType: TourType,
        coordinate: Coordinate,
        isAppendMode: Bool
    ) {
        // 이미 요청 진행 중일 경우 종료
        guard !isLoadingRelay.value else { return }
        isLoadingRelay.accept(true)
        useCase.fetchTourPlacesByLocation(
            pageNo: currentPage,
            longitude: coordinate.longitude,
            latitude: coordinate.latitude,
            radius: 3000,
            contentTypeId: tourType.contentTypeId
        )
        .observe(on: MainScheduler.instance)
        .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
        .subscribe(onSuccess: { [weak self] tourPlacePage in
            self?.handleTourPlaceResponse(tourPlacePage, isAppendMode: isAppendMode)
        }, onFailure: { [weak self] error in
            self?.handleTourPlaceError(error)
        })
        .disposed(by: disposeBag)
    }
}
