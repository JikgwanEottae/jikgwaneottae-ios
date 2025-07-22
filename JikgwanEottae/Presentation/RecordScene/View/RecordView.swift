//
//  RecordView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import SnapKit
import Then

final class RecordView: UIView {

    // MARK: - Property
    
    private let titleLabel = UILabel().then {
        $0.text = "기록"
        $0.numberOfLines = 1
        $0.font = UIFont.kbo(size: 25, family: .bold)
        $0.textColor = .black
    }
    
    public lazy var leftBarButtonItem = UIBarButtonItem(customView: titleLabel)

    
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
        self.backgroundColor = .white
    }

}
