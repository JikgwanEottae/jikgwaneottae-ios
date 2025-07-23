//
//  RecordViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import FSCalendar

final class RecordViewController: UIViewController {

    // MARK: - Properties
    
    private let recordView = RecordView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = recordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFSCalendarDelegate()
        configureNaviBarButtonItem()
        updateNaviTitle(to: Date())
    }
    
    // MARK: - Setup And Configuration
    
    private func configureNaviBarButtonItem() {
        let leftBarButtonItem = UIBarButtonItem(customView: recordView.titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setupFSCalendarDelegate() {
        self.recordView.fscalendarView.delegate = self
        self.recordView.fscalendarView.dataSource = self
    }
    
    // MARK: - UI Update Helpers
    
    private func updateNaviTitle(to date: Date) {
        let formattedDate = date.toFormattedString("yyyy년 MM월")
        self.navigationItem.title = formattedDate
    }
    
    private func updateDateLabel(to date: Date) {
        let formattedDate = date.toFormattedString("d. E")
        self.recordView.dateLabel.text = formattedDate
    }
    
}

// MARK: - FSCalendarDelegate Extension

extension RecordViewController: FSCalendarDelegate {
    // 캘린더가 좌우로 스와이프될 때 호출되는 함수
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // 네비게이션 타이틀을 해당 연도와 월로 변경
        updateNaviTitle(to: calendar.currentPage)
    }
    // 캘린더에서 날짜가 선택됬을 때 호출되는 함수
    func calendar(
        _ calendar: FSCalendar,
        didSelect date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        // 오늘 날짜 원 색상 변경
        calendar.appearance.todayColor = .systemGray5
        // 오늘 날짜 텍스트 색상 변경
        calendar.appearance.titleTodayColor = .primaryTextColor
        // 날짜 레이블을 선택 날짜로 업데이트
        updateDateLabel(to: date)
    }
}


extension RecordViewController: FSCalendarDataSource {
    
}
