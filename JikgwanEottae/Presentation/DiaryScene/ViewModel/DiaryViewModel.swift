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
    private let monthlyDiariesRelay = PublishRelay<[Diary]>()
    private let disposeBag = DisposeBag()
    
    // 뷰 컨트롤러부터 전달
    struct Input {
        let currentMonth: BehaviorRelay<Date>
    }
    // 뷰 컨트롤러에 전달
    struct Output {
        let monthlyDiaries: PublishRelay<[Diary]>
    }
    
    public init(useCase: DiaryUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        input.currentMonth
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] currentMonth in
                let formattedCurrentMonth = currentMonth
                    .toFormattedString("yyyy-MM")
                    .split(separator: "-")
                    .map { String($0) }
                let year = formattedCurrentMonth[0], month = formattedCurrentMonth[1]
                self?.fetchDiaries(year: year, month: month)
            })
            .disposed(by: disposeBag)

        return Output(
            monthlyDiaries: monthlyDiariesRelay
        )
    }
}

extension DiaryViewModel {
    private func fetchDiaries(year: String, month: String) {
        useCase.fetchDiaries(year: year, month: month)
            .subscribe(onSuccess: { [weak self] diaries in
                self?.monthlyDiariesRelay.accept(diaries)
            })
            .disposed(by: disposeBag)
    }
}
