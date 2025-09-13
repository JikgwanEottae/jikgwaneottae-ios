//
//  HomeViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    private let diaryUseCase: DiaryUseCaseProtocol
    private let kboGameUseCase: KBOGameUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewWillApper: PublishRelay<Void>
    }
    
    struct Output {
        let diaryStats: Observable<DiaryStats>
        let todayGames: Observable<[KBOGame]>
    }
    
    init(diaryUseCase: DiaryUseCaseProtocol, kboGameUseCase: KBOGameUseCaseProtocol) {
        self.diaryUseCase = diaryUseCase
        self.kboGameUseCase = kboGameUseCase
    }
    
    public func transform(input: Input) -> Output {
        let diaryStats = input.viewWillApper
            .filter { AppState.shared.needsStatisticsRefresh }
            .flatMapLatest { [weak self]  _ -> Observable<DiaryStats> in
                guard let self = self else { return .never() }
                return self.diaryUseCase.fetchDiaryStats()
                    .asObservable()
                    .catch { error in
                        return .empty()
                    }
            }
        
        let todayGames = input.viewWillApper
            .flatMapLatest { [weak self] _ -> Observable<[KBOGame]> in
                guard let self = self else { return .never()}
                return self.kboGameUseCase.fetchDailyGames(date: Date())
                    .asObservable()
                    .catch { error in
                        return .empty()
                    }
            }
        return Output(
            diaryStats: diaryStats,
            todayGames: todayGames
        )
    }
    
}
