//
//  DiaryGameInfoInputViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/22/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryGameInfoInputViewModel {
    private let game: KBOGame
    private let disposeBag = DisposeBag()
    
    struct Input {
        let favoriteTeam: Observable<String>
        let seat: Observable<String>
        let nextButtonTapped: Observable<Void>
    }
    
    struct Output {
        let teams: Driver<[String]>
        let inputData: Observable<(Int, String, String)>
    }
    
    init(game: KBOGame) {
        self.game = game
    }
}

extension DiaryGameInfoInputViewModel {
    public func transform(input: Input) -> Output {
        let teams = BehaviorRelay(value: [game.homeTeam, game.awayTeam])
        
        let data = input.nextButtonTapped
            .withLatestFrom(Observable.combineLatest(input.favoriteTeam, input.seat))
            .map { [gameId = game.id] (favoriteTeam, seat) in
                return (gameId, favoriteTeam, seat)
            }
        
        return Output(
            teams: teams.asDriver(),
            inputData: data
        )
    }
}
