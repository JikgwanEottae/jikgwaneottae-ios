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
    // 유스케이스
    private let usecase: DiaryUseCaseProtocol
    // 전체 직관 일기
    private let allDiariesRelay = BehaviorRelay<[Diary]>(value: [])
    private let disposeBag = DisposeBag()
    
    // 뷰 컨트롤러부터 전달
    struct Input {
        let selectedDate: Signal<String>
    }
    // 뷰 컨트롤러로 전달
    struct Output {
        let allDiaries: Driver<[Diary]>
    }
    
    public init(usecase: DiaryUseCaseProtocol) {
        self.usecase = usecase
        test()
    }
    
    public func transform(input: Input) -> Output {
        input.selectedDate
            .emit { date in
                print("선택된 날짜: \(date)")
            }
            .disposed(by: disposeBag)
        
        return Output(
            allDiaries: allDiariesRelay.asDriver()
        )
    }
    
    private func test() {
        usecase.fetchAllDiaries()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] diaries in
                self?.allDiariesRelay.accept(diaries)
            }.disposed(by: disposeBag)
    }
    
}
