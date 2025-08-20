//
//  ChipBar.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/20/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 수평 스크롤을 적용한 카테고리 칩 바입니다.

final class horizontalChipBar: UIView {
    // 진동 효과
    private let selectionFeedback = UISelectionFeedbackGenerator()
    // 버튼의 타이틀을 관리합니다.
    private var buttonTitles: [String] = []
    // 버튼을 관리합니다.
    private var buttons: [UIButton] = []
    
    // 현재 선택된 버튼의 인덱스입니다.
    private var selectedIndex = 0
    
    lazy var scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 2
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 11, bottom: 5, right: 11)
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        selectionFeedback.prepare()
     }
     
    @available(*, unavailable)
     required init?(coder: NSCoder) {
         super.init(coder: coder)
     }
     
     convenience init(titles: [String], selectedIndex: Int = 0) {
         self.init(frame: .zero)
         configure(titles: titles, selectedIndex: selectedIndex)
     }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.height
                .equalTo(scrollView.frameLayoutGuide)
        }
    }
    
    /// 기존의 버튼을 모두 제거하고, 새로운 버튼을 스택 뷰에 추가합니다.
    private func setupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        buttons = buttonTitles.enumerated().map { index, title in
            return createButton(title: title, isSelected: index == selectedIndex, index: index)
        }
        buttons.forEach { stackView.addArrangedSubview($0) }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.scrollToButton(at: self.selectedIndex, animated: false)
        }
    }
    
    /// 버튼을 생성합니다.
    private func createButton(title: String, isSelected: Bool, index: Int) -> UIButton {
        return UIButton(type: .custom).then {
            var titleAttributes = AttributeContainer()
            titleAttributes.font = UIFont(name: "GmarketSansMedium", size: 16)
            titleAttributes.foregroundColor = isSelected ? .primaryTextColor : .secondaryTextColor
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString(title, attributes: titleAttributes)
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
            $0.backgroundColor = isSelected ? .primaryBackgroundColor : .clear
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 12
            $0.configuration = config
            $0.tag = index
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    /// 버튼을 업데이트합니다.
    private func updateButton(at index: Int, isSelected: Bool) {
        let button = buttons[index]
        let title = buttonTitles[index]
        var titleAttri = AttributeContainer()
        titleAttri.font = UIFont(name: "GmarketSansMedium", size: 16)
        titleAttri.foregroundColor = isSelected ? .primaryTextColor : .secondaryTextColor
        var config = button.configuration ?? UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(title, attributes: titleAttri)
        UIView.animate(withDuration: 0.2) {
            button.backgroundColor = isSelected ? .primaryBackgroundColor : .clear
            button.configuration = config
        }
    }
    
    private func scrollToButton(at index: Int, animated: Bool = true) {
        guard buttons.indices.contains(index) else { return }
        layoutIfNeeded()
        let button = buttons[index]
        let buttonFrame = button.convert(button.bounds, to: scrollView)
        let targetX = buttonFrame.midX - scrollView.bounds.width / 2
        let maxX = scrollView.contentSize.width - scrollView.bounds.width
        let clampedX = max(0, min(targetX, maxX))
        scrollView.setContentOffset(CGPoint(x: clampedX, y: 0), animated: animated)
    }
    
    public func configure(titles: [String], selectedIndex: Int = 0) {
        self.buttonTitles = titles
        self.selectedIndex = selectedIndex
        setupButtons()
    }
    
    /// 버튼이 클릭됬을 때 이벤트입니다.
    @objc private func buttonTapped(_ sender: UIButton) {
        let newIndex = sender.tag
        guard newIndex != selectedIndex else { return }
        updateButton(at: selectedIndex, isSelected: false)
        updateButton(at: newIndex, isSelected: true)
        selectedIndex = newIndex
        scrollToButton(at: newIndex)
        selectionFeedback.selectionChanged()
        print("선택된 카테고리: \(buttonTitles[newIndex])")
    }
}
