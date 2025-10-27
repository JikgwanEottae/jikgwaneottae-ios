//
//  DiaryHomeViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryHomeViewModel: ViewModelType {
    private let useCase: DiaryUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedFilter: Observable<DiaryFilterType>
        let refreshTrigger: Observable<Void>
    }

    struct Output {
        let isLoading: Driver<Bool>
        let diaries: Driver<[Diary]>
    }
    
    init(useCase: DiaryUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension DiaryHomeViewModel {
    public func transform(input: Input) -> Output {
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        
        let diaries = Observable.merge(
            input.selectedFilter.map { _ in () },
            input.refreshTrigger
        )
            .withLatestFrom(input.selectedFilter)
            .withUnretained(self)
            .do(onNext: { owner, _ in
                isLoadingRelay.accept(true)
            })
            .flatMapLatest { owner, filterType -> Observable<[Diary]> in
                guard !AppState.shared.isGuestMode else {
                    return Observable.just([])
                }
                if filterType == .all {
                    return owner.useCase.fetchAllDiaries()
                        .asObservable()
                        .catchAndReturn([])
                } else {
                    return owner.useCase.fetchFilteredDiaries(filterType)
                        .asObservable()
                        .catchAndReturn([])
                }
            }
            .do(onNext: { _ in
                isLoadingRelay.accept(false)
                AppState.shared.needsDiaryRefresh = false
            })
            .asDriver(onErrorJustReturn: [])
        
        return Output(
            isLoading: isLoadingRelay.asDriver(),
            diaries: diaries
        )
    }
}
