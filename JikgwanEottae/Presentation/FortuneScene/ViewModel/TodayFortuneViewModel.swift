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
        let timePickerItems: Driver<[String]>
        let genderPickerItems: Driver<[String]>
        let kboTeamPickerItems: Driver<[String]>
        let fortune: Observable<Fortune>
        let isLoading: Signal<Bool>
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
        let isLoadingRelay = PublishRelay<Bool>()
        
        let fortune = input.completeButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(allValues)
            .filter { date, time, gender, kboTeam in
                if date.isEmpty || gender.isEmpty || kboTeam.isEmpty {
                    errorSubject.accept(())
                    return false
                }
                return true
            }
            .flatMapLatest { [weak self] (dateOfBirth, timeOfBirth, gender, favoriteKBOTeam) -> Observable<Fortune> in
                guard let self = self else { return .never()  }
                isLoadingRelay.accept(true)
                return self.useCase.fetchTodayFortune(
                    dateOfBirth: dateOfBirth,
                    timeOfBirth: timeOfBirth,
                    gender: gender,
                    favoriteKBOTeam: favoriteKBOTeam
                )
                .asObservable()
                .do(onNext: { _ in
                    isLoadingRelay.accept(false)
                }, onError: { _ in
                    isLoadingRelay.accept(false)
                })
                .catch { error in
                    print(error.localizedDescription)
                    return .empty()
                }
            }
        
        return Output(
            timePickerItems: Driver.just(Array(0...23).map{ String($0) }),
            genderPickerItems: Driver.just(["남성", "여성"]),
            kboTeamPickerItems: Driver.just(KBOTeam.allCases.map{ $0.rawValue }),
            fortune: fortune,
            isLoading: isLoadingRelay.asSignal(),
            error: errorSubject
        )
    }
    
}
