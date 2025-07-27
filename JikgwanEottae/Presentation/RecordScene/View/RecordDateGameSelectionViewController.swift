//
//  RecordDateGameSelectionViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/26/25.
//

import UIKit

import RxCocoa
import RxSwift

final class RecordDateGameSelectionViewController: UIViewController {
    
    private let recordDateGameSelectionView = RecordDateGameSelectionView()
    private let testData: [String] = ["2025-07-25", "2025-07-25", "2025-07-27"]
    private lazy var recordedGameBehaviorRelay = BehaviorRelay<[String]>(value: testData)
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = recordDateGameSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
    }
    
    private func fetchRecords(for date: String) -> Observable<[String]> {
        let filtered = testData.filter { $0 == date }
        // 실제 네트워크라면 RxAlamofire나 Moya 사용 후 Main 스케줄러로 observe
        return Observable.just(filtered)
            .delay(.milliseconds(200), scheduler: MainScheduler.instance) // 모의 딜레이
    }
    
    private func bindTableView() {
        let selectedDate = recordDateGameSelectionView.datePicker.rx.date
            .distinctUntilChanged()
            .map { $0.toFormattedString("yyyy-MM-dd") }
            .share()
        
        let recordsForDate = selectedDate
            .withUnretained(self)
              .flatMapLatest { owner, date in
                  return owner.fetchRecords(for: date)
              }
              .observe(on: MainScheduler.instance)
              .share()
        
        recordsForDate
            .bind(to: recordDateGameSelectionView.tableView.rx.items(
                cellIdentifier: RecordedGameTableViewCell.ID,
                cellType: RecordedGameTableViewCell.self)
            ) { row, element, cell in
                cell.configure(num: element)
            }
            .disposed(by: disposeBag)
        
        recordsForDate
            .withUnretained(self)
            .bind { owner, records in
                if records.isEmpty {
                    owner.recordDateGameSelectionView.tableView.setEmptyView(
                        image: UIImage(resource: .exclamation),
                        message: "경기 일정이 없거나 아직 경기 중이에요"
                    )
                } else {
                    owner.recordDateGameSelectionView.tableView.restore()
                }
                let height = CGFloat(max(records.count * 100, 100))
                owner.recordDateGameSelectionView.updateTableViewHeight(to: height)
            }
            .disposed(by: disposeBag)
    }
}
