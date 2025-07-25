//
//  RecordViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import FSCalendar
import RxSwift
import RxCocoa

final class RecordViewController: UIViewController {

    // MARK: - Properties

    private let recordView = RecordView()
    // 테스트 데이터 testData 를 날짜‑키 딕셔너리로 미리 만들어 두면 O(1) 조회 가능합니다.
    let testData: [(date: String, imageName: String)] = [
      ("2025-07-23", "test1"),
      ("2025-07-24", "test2"),
      ("2025-07-25", "test1"),
      ("2025-07-25", "test2"),
      ("2025-07-25", "test3"),
      ("2025-07-25", "test4"),
    ]
    // 테스트 데이터를 뿌려줄 릴레이
    private lazy var recordsBehaviorRelay = BehaviorRelay<[(date: String, imageName: String)]>(value: testData)
    // 선택된 날짜를 뿌려줄 릴레이
    private let selectedDateRelay = BehaviorRelay<String>(value: Date().toFormattedString("yyyy-MM-dd"))
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = recordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFSCalendarDelegate()
        configureNaviBarButtonItem()
        bindTableView()
        updateNaviTitle(to: Date())
    }
    
    // MARK: - Setup And Configuration
    
    private func configureNaviBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: recordView.titleLabel)
    }
    
    private func setupFSCalendarDelegate() {
        self.recordView.fscalendarView.delegate = self
        self.recordView.fscalendarView.dataSource = self
    }
    
    // MARK: - UI Update Helpers
    
    private func updateNaviTitle(to date: Date) {
        self.navigationItem.title = date.toFormattedString("yyyy년 MM월")
    }
    
    private func updateDateLabel(to date: Date) {
        self.recordView.selectedDateLabel.text = date.toFormattedString("d. E")
    }
    
    private func bindTableView() {
        let filteredRecords = Observable
            .combineLatest(recordsBehaviorRelay, selectedDateRelay)
            .map { records, selectedDate in
                records.filter { $0.date == selectedDate }
            }
            .share(replay: 1, scope: .forever)
        
        filteredRecords
            .bind(to: recordView.recordTableView.rx.items(
                cellIdentifier: RecordTableViewCell.ID,
                cellType: RecordTableViewCell.self)
            ) { row, element, cell in
                cell.configure(str: element.imageName)
            }
            .disposed(by: disposeBag)
        
        filteredRecords
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, items in
                if items.isEmpty {
                    owner.recordView.recordTableView.setEmptyView(
                        image: UIImage(resource: .docs),
                        message: "아직 직관 기록이 없어요"
                    )
                } else {
                    owner.recordView.recordTableView.restore()
                }
                let height = Constants.tableViewRowHeight * CGFloat(max(items.count, 1))
                owner.recordView.updateTableViewHeight(to: height)
            }
            .disposed(by: disposeBag)
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
        let dateString = date.toFormattedString("yyyy-MM-dd")
        selectedDateRelay.accept(dateString)
        updateDateLabel(to: date)
    }
    // 성능 최적화를 위해 나중에 리팩토링 필수
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        print(date)
        let selectedDate = date.toFormattedString("yyyy-MM-dd")
        let filtered = testData.filter { $0.date == selectedDate }
        if !filtered.isEmpty {
            return "⚾️"
        }
        return nil
    }
}

// MARK: - FSCalendarDataSource Extension

extension RecordViewController: FSCalendarDataSource {
    // 커스텀 셀 등록
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


