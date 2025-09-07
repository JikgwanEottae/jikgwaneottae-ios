//
//  MyPageViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/7/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let disposeBag = DisposeBag()
    private let sectionTitles = ["내 정보", "기타"]
    private let items = [
        ["프로필 사진 설정", "닉네임 설정"],
        ["이용약관", "개인정보 처리방침", "로그아웃", "회원탈퇴"]
    ]
    
    override func loadView() {
        self.view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBarButtonItem()
        setupDelegates()
        myPageView.headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 220)
        myPageView.tableView.tableHeaderView = myPageView.headerView
    }
    
    private func configureNaviBarButtonItem() {
        let leftBarButtonItem = UIBarButtonItem(customView: myPageView.titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setupDelegates() {
        myPageView.tableView.delegate = self
        myPageView.tableView.dataSource = self
    }
}

extension MyPageViewController: UITableViewDelegate {
    /// 섹션의 타이틀을 설정합니다.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        var config = UIListContentConfiguration.groupedHeader()
        config.text = sectionTitles[section]
        config.textProperties.font = .gMarketSans(size: 11, family: .medium)
        config.textProperties.color = .tertiaryTextColor
        headerView.contentConfiguration = config
        return headerView
    }
}

extension MyPageViewController: UITableViewDataSource {
    /// 커스텀 셀을 적용합니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingCell.ID,
            for: indexPath
        ) as? SettingCell
        else { return UITableViewCell() }
        let title = items[indexPath.section][indexPath.row]
        cell.configure(title: title)
        return cell
    }
    
    /// 섹션의 수를 지정합니다.
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    /// 섹션의 행 수를 지정합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
}
