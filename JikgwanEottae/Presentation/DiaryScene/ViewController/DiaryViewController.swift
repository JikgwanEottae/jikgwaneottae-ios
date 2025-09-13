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
    private var dataSource: UICollectionViewDiffableDataSource<Section, Diary>!
    private enum Section: CaseIterable { case main }
    private let selectedDayRelay = BehaviorRelay<Date>(value: Date())
    private let selectedMonthRelay = PublishRelay<Date>()
    private var currentMonthDiaries: [Diary] = []
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        configureNavigationBarItem()
        configureCalendarDelegates()
        configureDataSource()
        bindViewModel()
        bindCollectionView()
        updateNavigationTitle(to: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 직관 일기의 갱신이 필요한지 체크합니다.
        if AppState.shared.needsDiaryRefresh {
            let currentPage = diaryView.fscalendarView.currentPage
            let currentDay = diaryView.fscalendarView.selectedDate ?? Date()
            selectedMonthRelay.accept(currentPage)
            selectedDayRelay.accept(currentDay)
            AppState.shared.needsDiaryRefresh = false
        }
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: diaryView.titleLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(navigateToGameDateSelection)
        )
    }
    
    /// FSCalendar의 델리게이트와 데이터소스를 설정합니다.
    private func configureCalendarDelegates() {
        self.diaryView.fscalendarView.delegate = self
        self.diaryView.fscalendarView.dataSource = self
    }
    
    /// 직관 일기 컬렉션 뷰를 뷰 컨트롤러와 바인딩합니다.
    /// 셀 아이템 클릭 시 직관 일기 편집화면으로 이동합니다.
    private func bindCollectionView() {
        diaryView.collectionView.rx.itemSelected
            .compactMap { [weak self] indexPath in
                return self?.dataSource.itemIdentifier(for: indexPath)
            }
            .subscribe(onNext: { [weak self] selectedDiary in
                let diaryRepository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
                let diaryUseCase = DiaryUseCase(repository: diaryRepository)
                let diaryEditViewModel = DiaryEditViewModel(usecase: diaryUseCase, selectedDiary: selectedDiary)
                let diaryEditViewController = DiaryEditViewController(viewModel: diaryEditViewModel)
                let navigationController = UINavigationController(rootViewController: diaryEditViewController)
                navigationController.configureBarAppearnace()
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    /// 뷰 모델을 뷰 컨트롤러와 바인딩합니다.
    private func bindViewModel() {
        let input = DiaryViewModel.Input(
            selectedMonth: selectedMonthRelay,
            selectedDay: selectedDayRelay
        )
        let output = viewModel.transform(input: input)
        
        output.monthlyDiaries
            .withUnretained(self)
            .subscribe(onNext: { owner, diaries in
                owner.currentMonthDiaries = diaries
                owner.diaryView.fscalendarView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output.dailyDiaries
            .withUnretained(self)
            .subscribe(onNext: { owner, diaries in
                if diaries.isEmpty {
                    owner.diaryView.collectionView.setEmptyView(
                        image: UIImage(systemName: "questionmark.circle"),
                        message: "직관 일기 기록이 없어요"
                    )
                } else {
                    owner.diaryView.collectionView.restore()
                }
                owner.updateSnapshot(diaries: diaries)
            })
            .disposed(by: disposeBag)
    }
    
    /// 직관 일기 컬렉션뷰에 사용할 데이터 소스를 설정합니다.
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Diary>(
            collectionView: diaryView.collectionView,
            cellProvider: { collectionView, indexPath, diary in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DiaryCollectionViewCell.ID,
                    for: indexPath
                ) as? DiaryCollectionViewCell
                cell?.configure(diary: diary)
                return cell
            }
        )
        var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// 변경된 아이템에 따라 스냅샷을 업데이트합니다.
    private func updateSnapshot(diaries: [Diary]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Diary>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaries, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    /// 경기 결과에 따른 이벤트 표시 색상을 반환합니다.
    private func getEventColor(for diary: Diary) -> [UIColor] {
        guard let result = diary.result else { return [.yellowColor] }
        if result == "WIN" { return [.tossBlueColor] }
        return [.tossRedColor]
    }
}

extension DiaryViewController {
    /// 직관 일기 생성을 위한 경기 날짜 선택화면으로 이동합니다.
    @objc private func navigateToGameDateSelection() {
        let KBOGameRepository = KBOGameRepository(networkManager: KBOGameNetworkManager.shared)
        let KBOGameUseCase = KBOGameUseCase(repository: KBOGameRepository)
        let diaryGameDateSelectionViewModel = DiaryGameDateSelectionViewModel(useCase: KBOGameUseCase)
        let diaryGameDateSelectionViewController = DiaryGameDateSelectionViewController(viewModel: diaryGameDateSelectionViewModel)
        diaryGameDateSelectionViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryGameDateSelectionViewController, animated: true)
    }
}

extension DiaryViewController {
    /// 캘린더의 스와이프에 따라 네비게이션 타이틀이 변경됩니다.
    private func updateNavigationTitle(to date: Date) {
        self.navigationItem.title = date.toFormattedString("yyyy년 MM월")
    }
    
    /// 캘린더의 날짜 선택에 따라 레이블이 변경됩니다.
    private func updateSelectedDateLabel(to date: Date) {
        self.diaryView.selectedDateLabel.text = date.toFormattedString("d. E")
    }
}

// MARK: - FSCalendarDelegate Extension

extension DiaryViewController: FSCalendarDelegate {
    /// 캘린더가 좌우로 스와이프될 때 호출됩니다.
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        // 네비게이션 타이틀을 업데이트합니다.
        updateNavigationTitle(to: currentPage)
        // '월'이 변경될 때마다 이벤트를 방출
        selectedMonthRelay.accept(currentPage)
    }
    
    /// 캘린더에서 날짜가 선택됬을 때 호출됩니다.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 선택된 날짜 레이블을 업데이트합니다.
        updateSelectedDateLabel(to: date)
        selectedDayRelay.accept(date)
        calendar.appearance.todayColor = .systemGray5
        calendar.appearance.titleTodayColor = .primaryTextColor
    }
}

// MARK: - FSCalendarDataSource Extension

extension DiaryViewController: FSCalendarDataSource {
    /// 커스텀 셀을 등록합니다.
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
      return calendar.dequeueReusableCell(withIdentifier: CustomFSCalendarCell.ID, for: date, at: position) as! CustomFSCalendarCell
    }
    
    /// 캘린더에 표시가능한 최대 날짜를 설정합니다.
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    /// 캘린더의 날짜에 이벤트 표시합니다.
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = date.toFormattedString("yyyy-MM-dd")
        let count = currentMonthDiaries.filter { $0.gameDate == dateString }.count
        return min(count, 3)
    }
}

extension DiaryViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let dateString = date.toFormattedString("yyyy-MM-dd")
        let diaries = currentMonthDiaries.filter { $0.gameDate == dateString }
        if diaries.isEmpty { return nil }
        let colors = diaries.prefix(3).map { getEventColor(for: $0).first! }
        return colors
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        let dateString = date.toFormattedString("yyyy-MM-dd")
        let diaries = currentMonthDiaries.filter { $0.gameDate == dateString }
        if diaries.isEmpty { return nil }
        return diaries.prefix(3).map { getEventColor(for: $0).first! }
    }
}
