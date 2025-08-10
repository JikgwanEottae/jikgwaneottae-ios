////
////  CustomSegmentedControl.swift
////  JikgwanEottae
////
////  Created by 7aeHoon on 7/28/25.
////
///
import UIKit

import SnapKit
import Then

final class TeamSegmentedControl: UIControl {
    // 진동 효과
    private let selectionFeedback = UISelectionFeedbackGenerator()
    // 외부에서 노출이 가능하여 읽기는 가능하지만 쓰기는 불가
    private(set) var selectedSegmentIndex: Int = 0 {
        // 버튼의 태그로 selectedSegmentIndex가 변경됬을 때
        didSet {
            updateUI(animated: true)
            sendActions(for: .valueChanged)
        }
    }
    // 구단 이름을 저장
    public let segmentTitles: [String]
    // 현재 인덱스에 따라 선택된 구단 이름을 반환
    public var selectedTeam: String {
        // 읽기 전용 get
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
    // 구단 선택 버튼
    private var buttons: [UIButton] = []
    // 현재 선택된 구단을 강조하기 위한 뷰
    private let selectorView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
    }
    
    /// 경기에 참여한 구단명을 저장
    init(titles: [String]) {
        self.segmentTitles = titles
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        createButton()
        selectionFeedback.prepare()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 버튼의 프레임이 정해진 후 설렉터 뷰의 프레임을 정하기 위해 호출
        updateUI(animated: false)
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.addSubview(selectorView)
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    /// 세그먼트 컨트롤에 들어갈 커스텀 버튼을 생성
    private func createButton() {
        for (index, title) in segmentTitles.enumerated() {
            let btn = UIButton(type: .system).then {
                $0.setTitle(title, for: .normal)
                $0.titleLabel?.font = .gMarketSans(size: 17, family: .medium)
                $0.setTitleColor(.secondaryTextColor, for: .normal)
                $0.tag = index
                $0.addTarget(self, action: #selector(tapSegment(_:)), for: .touchUpInside)
            }
            buttons.append(btn)
            stackView.addArrangedSubview(btn)
        }
    }
    
    /// 세그먼트 컨트롤의 버튼 클릭에 따른 셀렉터 뷰의 이동 효과
    private func updateUI(animated: Bool) {
        guard buttons.indices.contains(selectedSegmentIndex) else { return }
        let selectorViewFrame = buttons[selectedSegmentIndex].frame.insetBy(dx: 4, dy: 4)
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.selectorView.frame = selectorViewFrame
            }
        } else {
            selectorView.frame = selectorViewFrame
        }
    }
    
    /// 세그먼트 컨트롤의 버튼이 클릭됬을 때
    @objc private func tapSegment(_ sender: UIButton) {
        selectionFeedback.selectionChanged()
        // 버튼의 태그를 저장
        selectedSegmentIndex = sender.tag
    }
}
