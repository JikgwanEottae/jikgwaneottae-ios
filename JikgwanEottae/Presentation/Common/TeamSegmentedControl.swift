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
    public var segmentTitles: [String] = []
    
    // 구단 선택 버튼
    private var buttons: [UIButton] = []
    
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

    // 현재 선택된 구단을 강조하기 위한 뷰
    public let selectorView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        selectionFeedback.prepare()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    /// 세그먼트 컨트롤에 들어갈 커스텀 버튼을 생성합니다.
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
    
    /// 홈팀, 어웨이팀, 응원팀을 통해 세그먼트 컨트롤을 설정합니다.
    public func configure(homeTeam: String, awayTeam: String, favoriteTeam: String?) {
        segmentTitles = [homeTeam, awayTeam]
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        createButton()
        if let favoriteTeam = favoriteTeam {
            selectedSegmentIndex = (homeTeam != favoriteTeam ? 1 : 0)
        }
        // 레이아웃 완료 후 위치 설정
        DispatchQueue.main.async {
            self.updateUI(animated: false)
        }
    }
    
    /// 세그먼트 컨트롤의 버튼 클릭에 따른 셀렉터 뷰를 이동시킵니다.
    public func updateUI(animated: Bool) {
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
    
    /// 세그먼트 컨트롤의 버튼이 클릭됬을 때 호출됩니다.
    @objc private func tapSegment(_ sender: UIButton) {
        selectionFeedback.selectionChanged()
        selectedSegmentIndex = sender.tag
    }
}
