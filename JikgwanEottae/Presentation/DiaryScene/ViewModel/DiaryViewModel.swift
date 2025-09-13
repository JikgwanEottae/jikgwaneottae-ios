//
//  DiaryViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryViewModel: ViewModelType {
    private let useCase: DiaryUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedMonth: PublishRelay<Date>
        let selectedDay: BehaviorRelay<Date>
    }

    struct Output {
        let monthlyDiaries: Observable<[Diary]>
        let dailyDiaries: Observable<[Diary]>
    }
    
    public init(useCase: DiaryUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let monthlyDiaries = input.selectedMonth
            .withUnretained(self)
            .flatMapLatest { owner, selectedMonth -> Observable<[Diary]> in
                return owner.useCase.fetchDiaries(selectedMonth: selectedMonth)
                    .asObservable()
                    .catchAndReturn([])
            }
        
        let dailyDiaries = input.selectedDay
            .withUnretained(self)
            .map { owner, selectedDay in
                owner.useCase.fetchDailyDiaries(selectedDay: selectedDay)
            }

        return Output(
            monthlyDiaries: monthlyDiaries,
            dailyDiaries: dailyDiaries
        )
    }
}
