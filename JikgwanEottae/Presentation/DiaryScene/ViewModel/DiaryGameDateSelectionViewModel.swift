//
//  DiaryGameDateSelectionViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/7/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryGameDateSelectionViewModel: ViewModelType {
    private let useCase: KBOGameUseCaseProtocol
    private let dailyGamesRelay = BehaviorRelay<[KBOGame]>(value: [])
    private let isLoadingRelay  = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedDate: Driver<Date>
    }
    
    struct Output {
        let dailyGames: Driver<[KBOGame]>
        let isLoading: Driver<Bool>
    }
    
    init(useCase: KBOGameUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        input.selectedDate
            .drive(onNext: { [weak self] date in
                self?.fetchDailyGames(date: date)
            })
            .disposed(by: disposeBag)
        
        return Output(
            dailyGames: dailyGamesRelay.asDriver(),
            isLoading: isLoadingRelay.asDriver()
        )
    }
}

extension DiaryGameDateSelectionViewModel {
    private func fetchDailyGames(date: Date) {
        isLoadingRelay.accept(true)
        
        useCase.fetchDailyGames(date: date)
            .subscribe(
                onSuccess: { [weak self] dailyGames in
                    self?.dailyGamesRelay.accept(dailyGames)
                    self?.isLoadingRelay.accept(false)
                },
                onFailure: { [weak self] _ in
                    self?.dailyGamesRelay.accept([])
                    self?.isLoadingRelay.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
