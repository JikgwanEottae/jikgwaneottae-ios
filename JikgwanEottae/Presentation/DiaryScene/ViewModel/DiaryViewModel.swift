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
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    public init(usecase: DiaryUseCaseProtocol) {
        self.usecase = usecase
    }
    
    public func transform(input: Input) -> Output {
        return Output()
    }
    
}
