//
//  FortuneGenderSelectionViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import Foundation

import RxSwift
import RxCocoa

final class FortuneGenderSelectionViewModel: ViewModelType {
    private let favoriteTeam: String
    private let disposeBag = DisposeBag()
    
    init(favoriteTeam: String) {
        self.favoriteTeam = favoriteTeam
    }
    
    struct Input {
        let maleButtonTapped: Observable<Void>
        let femaleButtonTapped: Observable<Void>
    }
    
    struct Output {
        let inputData: Observable<(String, String)>
    }
    
}

extension FortuneGenderSelectionViewModel {
    public func transform(input: Input) -> Output {
        let maleSelected = input.maleButtonTapped
            .map { (self.favoriteTeam, "M") }
        
        let femaleSelected = input.femaleButtonTapped
            .map { (self.favoriteTeam, "F") }
        
        let selectedData = Observable.merge(maleSelected, femaleSelected)
        
        return Output(inputData: selectedData)
    }
}
