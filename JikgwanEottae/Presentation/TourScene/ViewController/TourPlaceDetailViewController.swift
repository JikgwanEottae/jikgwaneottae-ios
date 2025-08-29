//
//  TourPlaceDetailViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/29/25.
//

import UIKit

import SnapKit
import Then
import Kingfisher

// MARK: - 관광 데이터의 상세보기를 위한 뷰 컨트롤러입니다.

final class TourPlaceDetailViewController: UIViewController {
    private let tourPlaceDetailView = TourPlaceDetailView()
    
    override func loadView() {
        self.view = tourPlaceDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTapped() {
        dismiss(animated: true)
    }

}
