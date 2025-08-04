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

final class DiaryViewController: UIViewController {
    
    private let diaryView = DiaryView()
    private let viewModel: DiaryViewModel
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
    // 캘린더에서 선택된 날짜를 방출하는 릴레이
    private let dateSelectedRelay = PublishRelay<String>()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFSCalendarDelegate()
        configureNaviBarButtonItem()
        configureBackBarButtonItem()
        bindTableView()
        configureNaviTitle(to: Date())
        createRecordButtonTapped()
        
        bindViewModel()
    }
    
    init(viewModel: any ViewModelType) {
        self.viewModel = viewModel as! DiaryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNaviBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: diaryView.titleLabel)
    }
    
    private func setupFSCalendarDelegate() {
        self.diaryView.fscalendarView.delegate = self
        self.diaryView.fscalendarView.dataSource = self
    }
    
    private func configureNaviTitle(to date: Date) {
        self.navigationItem.title = date.toFormattedString("yyyy년 MM월")
    }
    
    private func configureDateLabel(to date: Date) {
        self.diaryView.selectedDateLabel.text = date.toFormattedString("d. E")
    }
    
    private func bindTableView() {
        let filteredRecords = Observable
            .combineLatest(recordsBehaviorRelay, selectedDateRelay)
            .map { records, selectedDate in
                records.filter { $0.date == selectedDate }
            }
            .share(replay: 1, scope: .forever)
        
        filteredRecords
            .bind(to: diaryView.recordTableView.rx.items(
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
                    owner.diaryView.recordTableView.setEmptyView(
                        image: UIImage(resource: .docs),
                        message: "아직 직관 기록이 없어요"
                    )
                } else {
                    owner.diaryView.recordTableView.restore()
                }
                let height = Constants.tableViewRowHeight * CGFloat(max(items.count, 1))
                owner.diaryView.updateTableViewHeight(to: height)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let input = DiaryViewModel.Input(
            selectedDate: dateSelectedRelay.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        output.allDiaries
            .drive { diaries in
                print(diaries)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - FSCalendarDelegate Extension

extension DiaryViewController: FSCalendarDelegate {
    // 캘린더가 좌우로 스와이프될 때 호출되는 함수
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // 네비게이션 타이틀을 해당 연도와 월로 변경
        configureNaviTitle(to: calendar.currentPage)
    }
    
    // 캘린더에서 날짜가 선택됬을 때 호출되는 함수
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.appearance.todayColor = .systemGray5
        calendar.appearance.titleTodayColor = .primaryTextColor
        configureDateLabel(to: date)
        let dateString = date.toFormattedString("yyyy-MM-dd")
        selectedDateRelay.accept(dateString)
        dateSelectedRelay.accept(dateString)
    }
}

// MARK: - FSCalendarDataSource Extension

extension DiaryViewController: FSCalendarDataSource {
    // 커스텀 셀 등록
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
      return calendar.dequeueReusableCell(withIdentifier: CustomFSCalendarCell.ID, for: date, at: position) as! CustomFSCalendarCell
    }
    // 표시가능한 최대 날짜
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

extension DiaryViewController {
    private func createRecordButtonTapped() {
        diaryView.createRecordButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                let recordDateGameSelectionVC = RecordDateGameSelectionViewController()
                recordDateGameSelectionVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(recordDateGameSelectionVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
