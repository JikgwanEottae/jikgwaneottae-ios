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
    private let disposeBag = DisposeBag()
    
    struct Input {
        let dateOfBirth: Observable<String>
        let timeOfBirth: Observable<String>
        let sex: Observable<String>
        let kboTeam: Observable<String>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let error: PublishRelay<Void>
    }
    
    public func transform(input: Input) -> Output {
        let allValues = Observable.combineLatest(
            input.dateOfBirth,
            input.timeOfBirth,
            input.sex,
            input.kboTeam
        )
        
        let errorSubject = PublishRelay<Void>()
        
        input.completeButtonTapped
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(allValues)
            .filter { date, time, sex, kboTeam in
                if date.isEmpty || sex.isEmpty || kboTeam.isEmpty {
                    errorSubject.accept(())
                    return false
                } else {
                    return true
                }
            }
            .subscribe(onNext: { date, time, sex, kboTeam in
                print("=== 버튼이 눌렸을 때의 전체 값 ===")
                print("생년월일: \(date)")
                print("시간: \(time)")
                print("성별: \(sex)")
                print("KBO팀: \(kboTeam)")
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            error: errorSubject
        )
    }
    
}
