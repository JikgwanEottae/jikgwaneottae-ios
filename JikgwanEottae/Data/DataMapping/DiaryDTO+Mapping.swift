//
//  DiaryDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

//struct DiaryDTO: Decodable {
//    let id: String
//    let gameDate: Date
//    let gameTime: String
//    let ballpark: String
//    let homeTeam: String
//    let awayTeam: String
//    let homeScore: Int
//    let awayscore: Int
//    let favoriteTeam: String
//    let seat: String
//    let memo: String
//    let imageURL: String
//}
//
//extension DiaryDTO {
//    func toDomain() -> Diary {
//        Diary(
//            id: id,
//            gameDate: gameDate,
//            gameTime: gameTime,
//            ballpark: ballpark,
//            homeTeam: homeTeam,
//            awayTeam: awayTeam,
//            homeScore: homeScore,
//            awayscore: awayscore,
//            favoriteTeam: favoriteTeam,
//            seat: seat,
//            memo: memo,
//            imageURL: imageURL
//        )
//    }
//}

struct DiaryDTO: Decodable {
    let diaryId: Int
    let date: String
    let homeTeam: String
    let awayTeam: String
    let result: String
    let score: String
    let stadium: String
    let seat: String
    let memo: String
    let photoUrl: String?
}

extension DiaryDTO {
    func toDomain() -> Diary {
        Diary(
            id: diaryId,
            date: date,
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            result: result,
            score: score,
            stadium: stadium,
            seat: seat,
            memo: memo,
            photoUrl: photoUrl
        )
    }
}

