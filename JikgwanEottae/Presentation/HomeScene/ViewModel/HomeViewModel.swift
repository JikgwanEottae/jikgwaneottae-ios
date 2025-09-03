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
    private let useCase: DiaryUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidAppear: PublishRelay<Void>
    }
    
    struct Output {
        let diaryStats: Observable<DiaryStats>
    }
    
    init(useCase: DiaryUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let diaryStats = input.viewDidAppear
            .flatMapLatest { [weak self]  _ -> Observable<DiaryStats> in
                guard let self = self else { return .never() }
                return self.useCase.fetchDiaryStats()
                    .asObservable()
                    .catch { error in
                        print("DiaryStats 로드 실패: \(error.localizedDescription)")
                        return .empty()
                    }
            }
        return Output(diaryStats: diaryStats)
    }
    
}
