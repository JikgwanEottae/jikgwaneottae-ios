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
    private let usecase: DiaryUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // 뷰 컨트롤러부터 전달
    struct Input {
        let currentMonth: Signal<Date>
    }
    // 뷰 컨트롤러에 전달
    struct Output {
        let monthlyDiaries: Driver<[Diary]>
    }
    
    public init(usecase: DiaryUseCaseProtocol) {
        self.usecase = usecase
    }
    
    public func transform(input: Input) -> Output {
        let monthlyDiaries = input.currentMonth
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] date -> Driver<[Diary]> in
                let yearAndmonth = date.toFormattedString("yyyy-MM").split(separator: "-").map { String($0) }
                let year = yearAndmonth[0], month = yearAndmonth[1]
                return self.usecase.fetchDiaries(year: year, month: month).asDriver(onErrorJustReturn: [])
            }

        return Output(
            monthlyDiaries: monthlyDiaries
        )
    }
}

extension DiaryViewModel {
    
}
