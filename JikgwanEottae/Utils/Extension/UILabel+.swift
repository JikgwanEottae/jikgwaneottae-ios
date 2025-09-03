//
//  UILabel+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/28/25.
//

import UIKit

// MARK: - 텍스트의 행간 설정
extension UILabel {
    func setLineSpacing(spacing: CGFloat, alignment: NSTextAlignment = .left) {
        guard let text = text else { return }
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        style.alignment = alignment
        style.lineBreakStrategy = .hangulWordPriority
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}
