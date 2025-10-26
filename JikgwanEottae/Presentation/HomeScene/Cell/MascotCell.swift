//
//  MascotCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import UIKit

import Then
import SnapKit

// MARK: - 각 구단별 마스코트 캐릭터를 보여주기 위한 커스텀 컬렉션 뷰 셀입니다.

final class MascotCell: UICollectionViewCell {
    
    static let ID = "MascotCell"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        configureMascotImage()
        observefavoriteTeamChangeNotification()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        self.contentView.addSubview(imageView)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
}

// MARK: - Notification

private extension MascotCell {
    private func observefavoriteTeamChangeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleFavoriteTeamChange),
            name: .favoriteTeamDidChange,
            object: nil
        )
    }
    
    @objc func handleFavoriteTeamChange() {
        configureMascotImage()
    }
}

extension MascotCell {
    private func currentTeamCode() -> String {
        return UserDefaultsManager.shared.favoriteTeam ?? "samsung"
    }
    
    private func mascotImageNames(for teamCode: String) -> [String] {
        return [
            "\(teamCode)_bunny",
            "\(teamCode)_bear",
            "\(teamCode)_cat"
        ]
    }
    
    private func applyRandomMascotImage(from names: [String]) {
        let images = names.compactMap { UIImage(named: $0) }
        imageView.image = images.randomElement() ?? UIImage(named: "samsung_bunny")
    }
    
    private func configureMascotImage() {
        let teamCode = currentTeamCode()
        let imageNames = mascotImageNames(for: teamCode)
        applyRandomMascotImage(from: imageNames)
    }
}
