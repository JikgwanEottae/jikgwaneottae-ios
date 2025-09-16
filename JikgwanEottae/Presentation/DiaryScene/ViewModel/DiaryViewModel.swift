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
//            .filter{ _ in !AppState.shared.isGuestMode }
            .withUnretained(self)
            .flatMapLatest { owner, selectedMonth -> Observable<[Diary]> in
                guard !AppState.shared.isGuestMode else {
                    return Observable.just([])
                }
                return owner.useCase.fetchDiaries(selectedMonth: selectedMonth)
                    .asObservable()
                    .catchAndReturn([])
            }
        
        let dailyDiaries = Observable.combineLatest(
            monthlyDiaries,
            input.selectedDay.filter{ _ in !AppState.shared.isGuestMode }
        )
        .map { (diaries, selectedDay) -> [Diary] in
            guard !AppState.shared.isGuestMode else {
                 return []
             }
            let dateString = selectedDay.toFormattedString("yyyy-MM-dd")
            return diaries.filter { $0.gameDate == dateString }
        }

        return Output(
            monthlyDiaries: monthlyDiaries,
            dailyDiaries: dailyDiaries
        )
    }
}
