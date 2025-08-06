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
    // 선택된 날짜를 뿌려줄 릴레이
    private let selectedDateRelay = BehaviorRelay<String>(value: Date().toFormattedString("yyyy-MM-dd"))
    // 현재 '월'을 방출하는 릴레이
    private let currentMonthRelay = PublishRelay<Date>()
    private var monthlyDiaries: [Diary] = []
    private let diariesRelay = BehaviorRelay<[Diary]>(value: [])
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
        setupDummyDiaries()
        diaryView.fscalendarView.reloadData()
    }
    private func setupDummyDiaries() {
        monthlyDiaries = [
            // 2025-07월
            Diary(
                id: 28,
                gameDate: "2025-07-06",
                gameTime: "18:00:00",
                ballpark: "잠실야구장",
                homeTeam: "LG",
                awayTeam: "삼성",
                homeScore: 4,
                awayScore: 5,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A20",
                memo: "끝내기 안타의 짜릿함",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/e62668b9-de69-437e-9c3f-7d90c99aeacb.jpg"
            ),
            Diary(
                id: 27,
                gameDate: "2025-07-05",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "KT",
                homeScore: 1,
                awayScore: 8,
                favoriteTeam: "삼성",
                result: "LOSE",
                seat: "A19",
                memo: "선물 쿠폰 당첨 행운",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/93f9fea2-70eb-4ef2-8eeb-338774f7183e.jpg"
            ),
            Diary(
                id: 26,
                gameDate: "2025-07-04",
                gameTime: "18:00:00",
                ballpark: "고척스카이돔",
                homeTeam: "키움",
                awayTeam: "삼성",
                homeScore: 3,
                awayScore: 7,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A18",
                memo: "친구 생일 직관 선물",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/0af36754-fb88-4785-a6b3-e57bcbcbd3ca.jpg"
            ),
            Diary(
                id: 25,
                gameDate: "2025-07-03",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "SSG",
                homeScore: 6,
                awayScore: 4,
                favoriteTeam: "삼성",
                result: "LOSE",
                seat: "A17",
                memo: "아치 홈런의 순간 포착",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/9ba37c15-66d1-4e41-929d-79dd35f5293a.jpg"
            ),
            Diary(
                id: 24,
                gameDate: "2025-07-02",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "두산",
                homeScore: 5,
                awayScore: 3,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A16",
                memo: "야간경기의 열기 체험",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/33361ac3-f909-4243-ba87-25d89e4374c2.jpg"
            ),
            Diary(
                id: 23,
                gameDate: "2025-07-01",
                gameTime: "18:00:00",
                ballpark: "수원KT위즈파크",
                homeTeam: "KT",
                awayTeam: "삼성",
                homeScore: 1,
                awayScore: 10,
                favoriteTeam: "삼성",
                result: "LOSE",
                seat: "A15",
                memo: "첫 올스타전 분위기 체험",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/6b15b8fe-e52f-4e2f-be7e-eda3f7532d89.jpg"
            ),

            // 2025-08월
            Diary(
                id: 7,
                gameDate: "2025-08-05",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "키움",
                homeScore: 8,
                awayScore: 10,
                favoriteTeam: "삼성",
                result: "LOSE",
                seat: "A12",
                memo: "삼성과 SSG의 경기 직관 완료",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/bddd8165-c24f-421d-8d67-c241e7e36854.jpg"
            ),

            // 2025-06월
            Diary(
                id: 22,
                gameDate: "2025-06-12",
                gameTime: "18:00:00",
                ballpark: "창원NC파크",
                homeTeam: "NC",
                awayTeam: "삼성",
                homeScore: 3,
                awayScore: 8,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A14",
                memo: "추억의 응원가 합창",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/6252531c-7629-4e9d-b4e3-647a49684750.jpg"
            ),
            Diary(
                id: 21,
                gameDate: "2025-06-11",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "KIA",
                homeScore: 4,
                awayScore: 3,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A13",
                memo: "웨이브 응원 동참 완료",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/2c23a627-0dc6-4145-8ff0-d1168f87a043.jpg"
            ),
            Diary(
                id: 20,
                gameDate: "2025-06-10",
                gameTime: "18:00:00",
                ballpark: "잠실야구장",
                homeTeam: "LG",
                awayTeam: "삼성",
                homeScore: 5,
                awayScore: 9,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A12",
                memo: "더블헤더 1차전 관람",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/7720ca09-f819-4b15-a52f-2cc922588495.jpg"
            ),
            Diary(
                id: 19,
                gameDate: "2025-06-09",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "롯데",
                homeScore: 7,
                awayScore: 4,
                favoriteTeam: "삼성",
                result: "LOSE",
                seat: "A11",
                memo: "시즌 초반 첫 홈 승리",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/a7f86918-4e02-4bdb-9379-51b27ea3d694.jpg"
            ),
            Diary(
                id: 18,
                gameDate: "2025-06-08",
                gameTime: "18:00:00",
                ballpark: "잠실야구장",
                homeTeam: "두산",
                awayTeam: "삼성",
                homeScore: 2,
                awayScore: 6,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A10",
                memo: "별도 이벤트로 사인볼 획득",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/21d74991-13f7-4aeb-ae18-85b50e01adff.jpg"
            ),
            Diary(
                id: 17,
                gameDate: "2025-06-07",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "한화",
                homeScore: 8,
                awayScore: 1,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A9",
                memo: "치어리더 멋진 공연 포착",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/575b4195-6f3c-44a2-97e4-741a6d7fc4bd.jpg"
            ),
            Diary(
                id: 16,
                gameDate: "2025-06-06",
                gameTime: "18:00:00",
                ballpark: "사직야구장",
                homeTeam: "롯데",
                awayTeam: "삼성",
                homeScore: 2,
                awayScore: 5,
                favoriteTeam: "삼성",
                result: "LOSE",
                seat: "A8",
                memo: "가족과 함께 야구장 나들이",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/43fdf758-0e3f-40d1-a8b0-ea24cac26fc4.jpg"
            ),

            // 2025-05월
            Diary(
                id: 15,
                gameDate: "2025-05-11",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "NC",
                homeScore: 3,
                awayScore: 2,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A7",
                memo: "비로 인해 경기 중단 후 재개",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/7efdb2e2-adf5-4ba7-b6c7-73daa0ace003.jpg"
            ),
            Diary(
                id: 14,
                gameDate: "2025-05-10",
                gameTime: "18:00:00",
                ballpark: "인천SSG랜더스필드",
                homeTeam: "SSG",
                awayTeam: "삼성",
                homeScore: 4,
                awayScore: 7,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A6",
                memo: "랜더스데이 기념 행사 관람",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/3586766f-2796-4635-85ec-9ab8937132a3.jpg"
            ),
            Diary(
                id: 13,
                gameDate: "2025-05-09",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "키움",
                homeScore: 6,
                awayScore: 5,
                favoriteTeam: "삼성",
                result: "LOSE",
                seat: "A5",
                memo: "매진 경기, 뜨거운 응원 열기",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/ad7bb994-5ef3-4163-a48b-f18586159d63.jpg"
            ),
            Diary(
                id: 12,
                gameDate: "2025-05-09",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "키움",
                homeScore: 6,
                awayScore: 5,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A5",
                memo: "매진 경기, 뜨거운 응원 열기",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/25f55758-49b7-48c5-b6aa-48042c095f26.jpg"
            ),
            Diary(
                id: 11,
                gameDate: "2025-05-08",
                gameTime: "18:00:00",
                ballpark: "수원KT위즈파크",
                homeTeam: "KT",
                awayTeam: "삼성",
                homeScore: 1,
                awayScore: 9,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A4",
                memo: "불펜 투수의 호투가 인상적",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/f28d1df4-905c-40cf-b597-6e317b8e2509.jpg"
            ),
            Diary(
                id: 10,
                gameDate: "2025-05-07",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "LG",
                homeScore: 2,
                awayScore: 4,
                favoriteTeam: "삼성",
                result: "LOSE",
                seat: "A3",
                memo: "첫 직관 경험, 설렘 가득",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/be4c90d7-bb7b-4891-a2ed-cb1453b87b8f.jpg"
            ),
            Diary(
                id: 9,
                gameDate: "2025-05-06",
                gameTime: "18:00:00",
                ballpark: "광주-KIA챔피언스필드",
                homeTeam: "KIA",
                awayTeam: "삼성",
                homeScore: 3,
                awayScore: 8,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A2",
                memo: "역전승으로 짜릿한 승리",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/454af595-3d2c-4bee-ae50-eb3f8b19dd2a.jpg"
            ),
            Diary(
                id: 8,
                gameDate: "2025-05-05",
                gameTime: "18:00:00",
                ballpark: "대구삼성라이온즈파크",
                homeTeam: "삼성",
                awayTeam: "두산",
                homeScore: 5,
                awayScore: 2,
                favoriteTeam: "삼성",
                result: "WIN",
                seat: "A1",
                memo: "친구와 함께 직관",
                imageURL: "https://jikgwaneottae.s3.ap-northeast-2.amazonaws.com/a2e801b3-81b2-479a-b600-c75abb19ad20.jpg"
            ),
        ]
        
        diariesRelay.accept(monthlyDiaries)

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
    
    // MARK: - 테이블 뷰와 바인드
    
    private func bindTableView() {
        let filteredDiaries = Observable
            .combineLatest(diariesRelay, selectedDateRelay)
            .map { diaries, selectedDate in
                diaries.filter { $0.gameDate == selectedDate }
            }
            .share(replay: 1, scope: .forever)
        
        filteredDiaries
            .bind(to: diaryView.recordTableView.rx.items(
                cellIdentifier: RecordTableViewCell.ID,
                cellType: RecordTableViewCell.self)
            ) { row, diary, cell in
                cell.configure(diary: diary)
            }
            .disposed(by: disposeBag)
        
        filteredDiaries
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, diaries in
                if diaries.isEmpty {
                    owner.diaryView.recordTableView.setEmptyView(
                        image: UIImage(resource: .docs),
                        message: "아직 직관 기록이 없어요"
                    )
                } else {
                    owner.diaryView.recordTableView.restore()
                }
                let height = Constants.tableViewRowHeight * CGFloat(max(diaries.count, 1))
                owner.diaryView.updateTableViewHeight(to: height)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - 뷰 모델과 바인드
    
    private func bindViewModel() {
        let input = DiaryViewModel.Input(
            currentMonth: currentMonthRelay.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        output.monthlyDiaries
            .drive(onNext: { [weak self] diaries in
//                self?.monthlyDiaries = diaries
//                self?.diaryView.fscalendarView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - FSCalendarDelegate Extension

extension DiaryViewController: FSCalendarDelegate {
    /// 캘린더가 좌우로 스와이프될 때 호출되는 함수
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPage = calendar.currentPage
        // 네비게이션 타이틀 변경
        configureNaviTitle(to: currentPage)
        // '월'이 변경될 때마다 이벤트를 방출
        currentMonthRelay.accept(currentPage)

    }
    /// 캘린더에서 날짜가 선택됬을 때 호출되는 함수
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
    /// 커스텀 셀 등록 함수
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
      return calendar.dequeueReusableCell(withIdentifier: CustomFSCalendarCell.ID, for: date, at: position) as! CustomFSCalendarCell
    }
    /// 캘린더에 표시가능한 최대 날짜 설정 함수
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    /// 이벤트 표시 함수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let date = date.toFormattedString("yyyy-MM-dd")
        return monthlyDiaries.contains { $0.gameDate == date } ? 1 : 0
    }
}

// MARK: - navigate Extension

extension DiaryViewController {
    /// 직관 일기 생성 버튼을 클릭했을 때 화면 전환 함수
    private func createRecordButtonTapped() {
        diaryView.createRecordButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                let diaryGameDateSelectionViewController = DiaryGameDateSelectionViewController()
                diaryGameDateSelectionViewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(diaryGameDateSelectionViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
