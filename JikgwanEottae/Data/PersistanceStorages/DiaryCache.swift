//
//  DiaryCache.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/12/25.
//

import Foundation

// MARK: - 직관 일기를 관리하는 싱글톤 캐시입니다.

final class DiaryCache {
    static let shared = DiaryCache()
    private let cache = NSCache<NSString, NSArray>()
    
    private init() {}
    
    /// 월(yyyy-MM) 단위로 직관 일기를 저장합니다.
    public func setMonthlyDiaries(_ diaries: [Diary], for monthKey: String) {
        cache.setObject(diaries as NSArray, forKey: monthKey as NSString)
    }
    
    /// 월(yyyy-MM) 단위로 직관 일기를 조회합니다.
    public func getMonthlyDiaries(for monthKey: String) -> [Diary]? {
        return cache.object(forKey: monthKey as NSString) as? [Diary]
    }
    
    /// 해당 날짜(yyyy-MM-dd)의 직관 일기를 조회합니다.
    public func getDailyDiaries(for date: String, in monthKey: String) -> [Diary] {
        guard let diaries = getMonthlyDiaries(for: monthKey) else { return [] }
        return diaries.filter { $0.gameDate == date }
    }
    
    /// 기존이 존재하는 캐시에 직관 일기를 추가합니다.
    public func appendDiary(_ diary: Diary, for monthKey: String) {
        if var cached = getMonthlyDiaries(for: monthKey) {
            cached.append(diary)
            setMonthlyDiaries(cached, for: monthKey)
        } else {
            setMonthlyDiaries([diary], for: monthKey)
        }
    }
    
    ///  아이디가 일치하는 직관 일기 캐시를 업데이트(수정)합니다.
    public func updateDiary(_ diary: Diary, for monthKey: String) {
        guard var cached = getMonthlyDiaries(for: monthKey) else { return }
        if let index = cached.firstIndex(where: { $0.id == diary.id }) {
            cached[index] = diary
            setMonthlyDiaries(cached, for: monthKey)
        }
    }
    
    /// 아이디가 일치하는 직관 일기 캐시를 삭제합니다.
    public func removeDiary(id: Int, for monthKey: String) {
        guard var cached = getMonthlyDiaries(for: monthKey) else { return }
        cached.removeAll { $0.id == id }
        setMonthlyDiaries(cached, for: monthKey)
    }
    
    /// 해당 월의 캐시 여부를 확인합니다.
    public func exists(monthKey: String) -> Bool {
        return getMonthlyDiaries(for: monthKey) != nil
    }
    
    /// 월 단위로 저장된 캐시를 삭제합니다.
    public func remove(for monthKey: String) {
        cache.removeObject(forKey: monthKey as NSString)
    }
    
    /// 캐시를 초기화합니다.
    public func clear() {
        cache.removeAllObjects()
    }
}
