//
//  HomeView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import SnapKit
import Then

final class HomeView: UIView {

    // MARK: - Property
    
    let titleLabel = UILabel().then {
        $0.text = "직관어때?"
        $0.numberOfLines = 1
        $0.font = UIFont.kbo(size: 25, family: .bold)
        $0.textColor = .black
    }
    
    
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI

    private func setupUI() {
        self.backgroundColor = .primarybackgroundColor
    }


}
