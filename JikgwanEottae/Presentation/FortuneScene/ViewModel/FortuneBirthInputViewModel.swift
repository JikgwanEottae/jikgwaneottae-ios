//
//  FortuneBirthInputViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import Foundation

import RxSwift
import RxCocoa

final class FortuneBirthInputViewModel: ViewModelType {
    private let favoriteTeam: String
    private let gender: String
    private let useCase: TodayFortuneUseCase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let birth: Observable<String>
        let time: Observable<String>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let showEmptyAlert: Signal<Void>
        let fetchSuccess: Observable<Fortune>
        let fetchFailure: Signal<Void>
        let isLoading: Driver<Bool>
    }
    
    init(
        favoriteTeam: String,
        gender: String,
        useCase: TodayFortuneUseCase
    ) {
        self.favoriteTeam = favoriteTeam
        self.gender = gender
        self.useCase = useCase
    }
}

extension FortuneBirthInputViewModel {
    public func transform(input: Input) -> Output {
        let showEmptyAlert = PublishRelay<Void>()
        let success = PublishRelay<Fortune>()
        let failure = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        input.completeButtonTapped
            .withLatestFrom(Observable.combineLatest(
                input.birth,
                input.time
            ))
            .flatMapLatest { [weak self] (date, time) -> Observable<Fortune> in
                guard let self = self else { return .empty() }
                guard !date.isEmpty else {
                    showEmptyAlert.accept(())
                    return .empty()
                }
                let time = time.isEmpty ? nil : Int(time)
                isLoading.accept(true)
                return useCase.fetchTodayFortune(
                    date: date,
                    time: time,
                    gender: gender,
                    favoriteTeam: favoriteTeam
                )
                .asObservable()
            }
            .subscribe(onNext: { fortune in
                success.accept(fortune)
                isLoading.accept(false)
            }, onError: { error in
                failure.accept(())
                isLoading.accept(false)
            })
            .disposed(by: disposeBag)
        
        return Output(
            showEmptyAlert: showEmptyAlert.asSignal(),
            fetchSuccess: success.asObservable(),
            fetchFailure: failure.asSignal(),
            isLoading: isLoading.asDriver()
        )
    }
}
