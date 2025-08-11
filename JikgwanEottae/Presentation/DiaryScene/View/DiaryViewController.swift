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
    private let selectedDateRelay = BehaviorRelay<String>(value: Date().toFormattedString("yyyy-MM-dd"))
    private let currentMonthRelay = BehaviorRelay<Date>(value: Date())
    private var monthlyDiaries: [Diary] = []
    private let diariesRelay = BehaviorRelay<[Diary]>(value: [])
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
        setupFSCalendarDelegate()
        configureNaviBarButtonItem()
        configureNaviTitle(to: Date())
        configureDataSource()
        createRecordButtonTapped()
        bindCollectionView()
        bindViewModel()
        diaryView.fscalendarView.reloadData()
    }
    
    /// 네비게이션 왼쪽 바 버튼 아이템에 타이틀을 설정합니다.
    private func configureNaviBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: diaryView.titleLabel)
    }
    
    /// FSCalendar의 델리게이트와 데이터소스를 설정합니다.
    private func setupFSCalendarDelegate() {
        self.diaryView.fscalendarView.delegate = self
        self.diaryView.fscalendarView.dataSource = self
    }
    
    /// 네비게이션 타이틀을 설정합니다.
    /// 캘린더의 스와이프에 따라 네비게이션 타이틀이 변경됩니다.
    private func configureNaviTitle(to date: Date) {
        self.navigationItem.title = date.toFormattedString("yyyy년 MM월")
    }
    
    /// 달력에서 선택된 날짜를 표시합니다.
    /// 캘린더의 날짜 선택에 따라 레이블이 변경됩니다.
    private func configureDateLabel(to date: Date) {
        self.diaryView.selectedDateLabel.text = date.toFormattedString("d. E")
    }
    
    /// 직관 일기 컬렉션 뷰를 뷰 컨트롤러와 바인딩합니다.
    /// 셀 아이템 클릭 시 직관 일기 편집화면으로 이동합니다.
    private func bindCollectionView() {
        diaryView.collectionView.rx.itemSelected
            .withUnretained(self)
            .compactMap { owner, indexPath in
                return owner.dataSource.itemIdentifier(for: indexPath)
            }
            .subscribe(onNext: { diary in
                
            })
            .disposed(by: disposeBag)
    }
    
    /// 뷰 모델을 뷰 컨트롤러와 바인딩합니다.
    private func bindViewModel() {
        let input = DiaryViewModel.Input(
            currentMonth: currentMonthRelay
        )
        
        let output = viewModel.transform(input: input)
        
        output.monthlyDiaries
            .withUnretained(self)
            .subscribe(onNext: { owner, diaries in
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
                ) as! DiaryCollectionViewCell
                cell.configure(diary: diary)
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
    
    /// 직관 일기 생성 버튼의 클릭 이벤트를 받습니다.
    /// 직관 일기 생성 화면으로 이동합니다.
    private func createRecordButtonTapped() {
        diaryView.createDiaryButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                let KBOGameRepository = KBOGameRepository(networkManager: KBOGameNetworkManager.shared)
                let KBOGameUseCase = KBOGameUseCase(repository: KBOGameRepository)
                let diaryGameDateSelectionViewModel = DiaryGameDateSelectionViewModel(useCase: KBOGameUseCase)
                let diaryGameDateSelectionViewController = DiaryGameDateSelectionViewController(viewModel: diaryGameDateSelectionViewModel)
                diaryGameDateSelectionViewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(diaryGameDateSelectionViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - FSCalendarDelegate Extension

extension DiaryViewController: FSCalendarDelegate {
    /// 캘린더가 좌우로 스와이프될 때 호출됩니다.
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        // 네비게이션 타이틀 변경
        configureNaviTitle(to: currentPage)
        // '월'이 변경될 때마다 이벤트를 방출
        currentMonthRelay.accept(currentPage)
    }
    
    /// 캘린더에서 날짜가 선택됬을 때 호출됩니다.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureDateLabel(to: date)
        calendar.appearance.todayColor = .systemGray5
        calendar.appearance.titleTodayColor = .primaryTextColor
        let dateString = date.toFormattedString("yyyy-MM-dd")
        selectedDateRelay.accept(dateString)
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
        let date = date.toFormattedString("yyyy-MM-dd")
        return monthlyDiaries.contains { $0.gameDate == date } ? 1 : 0
    }
}
