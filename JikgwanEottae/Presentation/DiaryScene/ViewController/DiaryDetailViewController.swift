//
//  DiaryDetailViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/28/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 직관 일기 상세보기를 위한 뷰 컨트롤러입니다.

final class DiaryDetailViewController: UIViewController {
    private let diaryDetailView = DiaryDetailView()
    private let disposeBag = DisposeBag()

    override func loadView() {
        self.view = diaryDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "승리"
        hideBackBarButtonItem()
        hideKeyboardWhenTappedAround()
        configureNavigationBarItem()
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        let editAction = UIAction(
            title: "수정",
            image: UIImage(systemName: "pencil")
        ) { [weak self] _ in
            self?.handleEdit()
        }
        
        let deleteAction = UIAction(
            title: "삭제",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { [weak self] _ in
            self?.handleDelete()
        }
        
        let menu = UIMenu(
            title: "메뉴",
            children: [editAction, deleteAction]
        )
        
        let ellipsisItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            menu: menu
        )
        
        self.navigationItem.rightBarButtonItem = ellipsisItem
    }
    

}


extension DiaryDetailViewController {
    @objc private func ellipsisButtonTapped() {
        print("ellipsisButtonTapped")
    }
    
    private func handleEdit() {
        print("수정 버튼 tapped")
    }

    private func handleDelete() {
        print("삭제 버튼 tapped")
    }
}
