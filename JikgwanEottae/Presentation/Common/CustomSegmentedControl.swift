//
//  CustomSegmentedControl.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/28/25.
//

import UIKit

import SnapKit
import Then

final class CustomSegmentedControl: UIControl {
    // 진동 효과
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    // 선택된 세그먼트 인덱스
    private(set) var selectedSegmentIndex: Int = 0 {
        didSet {
            selectionFeedback.prepare()
            selectionFeedback.selectionChanged()
            // 값 변경 시 UI 갱신 및 이벤트 전송
            updateUI(animated: true)
            sendActions(for: .valueChanged)
        }
    }
    // 세그먼트 타이틀 배열
    public var segmentTitles: [String] {
        didSet {
            reloadSegments()
            selectedSegmentIndex = 0
            // 레이아웃이 완료된 이후에 디폴트 선택 표시
            setNeedsLayout()
        }
    }
    
    public var selectedTitle: String {
        return segmentTitles[selectedSegmentIndex]
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 2
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.backgroundColor = .secondaryBackgroundColor
    }
    
    private var buttons: [UIButton] = []
    
    private let selectorView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
    }
    
    // MARK: - Lifecycle
    
    init(titles: [String]) {
        self.segmentTitles = titles
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.segmentTitles = []
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.addSubview(selectorView)
        reloadSegments()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI(animated: false)
    }
    
    // MARK: - Segment Setup
    
    private func reloadSegments() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        
        for (index, title) in segmentTitles.enumerated() {
            let btn = UIButton(type: .system).then {
                $0.setTitle(title, for: .normal)
//                $0.titleLabel?.font = .pretendard(size: 17, family: .semiBold)
                $0.titleLabel?.font = .gMarketSans(size: 17, family: .medium)
                $0.setTitleColor(.white, for: .normal)
                $0.tag = index
                $0.addTarget(self, action: #selector(tapSegment(_:)), for: .touchUpInside)
            }
            buttons.append(btn)
            stackView.addArrangedSubview(btn)
        }
    }
    
    // MARK: - UI Update
    
    private func updateUI(animated: Bool) {
        for (index, btn) in buttons.enumerated() {
            btn.setTitleColor(
                index == selectedSegmentIndex
                ? .white
                : .tertiaryTextColor,
                for: .normal
            )
        }
        
        switch selectedSegmentIndex {
        case 0: selectorView.backgroundColor = .tossBlueColor
        case 1: selectorView.backgroundColor = .tossRedColor
        default: selectorView.backgroundColor = .white
        }
        
        guard buttons.indices.contains(selectedSegmentIndex) else { return }
        let targetFrame = buttons[selectedSegmentIndex].frame.insetBy(dx: 4, dy: 4)
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.selectorView.frame = targetFrame
            }
        } else {
            selectorView.frame = targetFrame
        }
    }
    
    // MARK: - Actions
    
    @objc private func tapSegment(_ sender: UIButton) {
        selectionFeedback.prepare()
        selectedSegmentIndex = sender.tag
    }
}
