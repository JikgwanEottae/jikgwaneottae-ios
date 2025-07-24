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
        updateTableView()
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
        self.recordView.selectedDateLabel.text = formattedDate
    }
    
    private func updateTableView() {
        recordView.recordTableView.setEmptyView(
            image: UIImage(resource: .docs),
            message: "아직 직관 기록이 없어요"
        )
        
//        recordView.recordTableView.restore()
    }
    
}

// MARK: - FSCalendarDelegate Extension

extension RecordViewController: FSCalendarDelegate {
    /// placeholder(이전·다음 달) 날짜는 선택을 금지
    func calendar(_ calendar: FSCalendar,
                  shouldSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) -> Bool {
      return monthPosition == .current
    }
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

// MARK: - FSCalendarDataSource Extension

extension RecordViewController: FSCalendarDataSource {
    func calendar(
        _ calendar: FSCalendar,
        numberOfEventsFor date: Date
    ) -> Int {
        return 0
    }
    
//    func calendar(
//        _ calendar: FSCalendar,
//        subtitleFor date: Date
//    ) -> String? {
//      return "⚾️"
//    }
    
    func calendar(
      _ calendar: FSCalendar,
      cellFor date: Date,
      at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
      return calendar.dequeueReusableCell(
        withIdentifier: CustomFSCalendarCell.ID,
        for: date,
        at: position
      ) as! CustomFSCalendarCell
    }
}

extension RecordViewController: FSCalendarDelegateAppearance {
    
}



