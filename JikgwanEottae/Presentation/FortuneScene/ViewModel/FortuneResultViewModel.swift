//
//  FortuneResultViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import Foundation

import RxSwift
import RxCocoa

final class FortuneResultViewModel: ViewModelType {
    private let fortune: Fortune
    private let disposeBag = DisposeBag()
    
    init(fortune: Fortune) {
        self.fortune = fortune
    }
    
    struct Input {
        
    }
    
    struct Output {
        let fortune: Driver<Fortune>
    }
    
}
extension FortuneResultViewModel {
    public func transform(input: Input) -> Output {
        
        
        return Output(
            fortune: Driver.just(fortune)
        )
    }
}
