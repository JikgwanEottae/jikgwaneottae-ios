//
//  BottomTableSheetViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/19/25.
//

import UIKit

import SnapKit
import Then

final class BottomTableSheetViewController: UIViewController {
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 16, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .center
        $0.numberOfLines = 1
    }
    
    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorInset = .zero
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = false
    }
    
    private let items: [String]
    private var selectedItem: String?
    private let sheetHeight: CGFloat
    public var onItemSelected: ((String) -> Void)?
    public var onDismiss: (() -> Void)?
    
    // MARK: - Initializer
    init(
        title: String,
        items: [String],
        selectedItem: String? = nil,
        sheetHeight: CGFloat
    ) {
        self.items = items
        self.selectedItem = selectedItem
        self.sheetHeight = sheetHeight
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        configureSheetStyle()
        configureTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onDismiss?()
    }
}

// MARK: - UI 구성

private extension BottomTableSheetViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.white
        [titleLabel, tableView].forEach { view.addSubview($0) }
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top
                .equalToSuperview()
                .offset(20)
            $0.leading.trailing
                .equalToSuperview()
                .inset(12)
        }
        
        tableView.snp.makeConstraints {
            $0.top
                .equalTo(titleLabel.snp.bottom)
                .offset(20)
            $0.leading.trailing.bottom
                .equalToSuperview()
        }
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configureSheetStyle() {
        if let sheet = sheetPresentationController {
            sheet.detents = [
                .custom(resolver: {[weak self] _ in self?.sheetHeight})
            ]
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
        }
    }
}

// MARK: - UITableView Delegate & DataSource

extension BottomTableSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = items[indexPath.row]
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont.pretendard(size: 18, family: .medium)
        cell.textLabel?.textColor = UIColor.Text.tertiaryColor
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = items[indexPath.row]
        onItemSelected?(selected)
        dismiss(animated: true)
    }
}
