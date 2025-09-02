//
//  TodayFortuneViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

import RxSwift
import RxCocoa

final class TodayFortuneViewModel: ViewModelType {
    private let useCase: TodayFortuneUseCase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let dateOfBirth: Observable<String>
        let timeOfBirth: Observable<String>
        let gender: Observable<String>
        let favoriteKBOTeam: Observable<String>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let error: PublishRelay<Void>
    }
    
    init(useCase: TodayFortuneUseCase) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let allValues = Observable.combineLatest(
            input.dateOfBirth,
            input.timeOfBirth,
            input.gender,
            input.favoriteKBOTeam
        )
        
        let errorSubject = PublishRelay<Void>()
        
        input.completeButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(allValues)
            .filter { date, time, gender, kboTeam in
                if date.isEmpty || gender.isEmpty || kboTeam.isEmpty {
                    errorSubject.accept(())
                    return false
                }
                return true
            }
            .subscribe(onNext: { dateOfBirth, timeOfBirth, gender, favoriteKBOTeam in
                self.useCase.fetchTodayFortune(dateOfBirth: dateOfBirth, timeOfBirth: timeOfBirth, gender: gender, favoriteKBOTeam: favoriteKBOTeam)
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            error: errorSubject
        )
    }
    
}
