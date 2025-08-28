//
//  UIImage+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/27/25.
//

import UIKit

extension UIImage {
    static func circularNumberImage(
        number: String? = nil,
        size: CGSize = CGSize(width: 17, height: 17),
        backgroundColor: UIColor = .systemBlue,
        textColor: UIColor = .white,
        fontSize: CGFloat = 8,
        borderWidth: CGFloat = 1,
        borderColor: UIColor = .white,
        centerDotColor: UIColor = .white,
        centerDotRatio: CGFloat = 0.35
    ) -> UIImage? {
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            let cgContext = context.cgContext
            
            // 원형 배경 그리기
            let circleRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
            cgContext.setFillColor(backgroundColor.cgColor)
            cgContext.fillEllipse(in: circleRect)
            
            // 테두리 그리기
            if borderWidth > 0 {
                cgContext.setStrokeColor(borderColor.cgColor)
                cgContext.setLineWidth(borderWidth)
                cgContext.strokeEllipse(in: circleRect)
            }
            
            // 숫자가 있으면 텍스트 그리기, 없으면 가운데 흰색 원 그리기
            if let number = number, !number.isEmpty {
                // 텍스트 그리기
                let font = UIFont.pretendard(size: fontSize, family: .semiBold) // 지도에서 더 잘 보이도록 semibold 사용
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: textColor
                ]
                
                let attributedString = NSAttributedString(string: number, attributes: attributes)
                let textSize = attributedString.size()
                
                // 텍스트를 중앙에 배치
                let textRect = CGRect(
                    x: (size.width - textSize.width) / 2,
                    y: (size.height - textSize.height) / 2,
                    width: textSize.width,
                    height: textSize.height
                )
                
                attributedString.draw(in: textRect)
            } else {
                // 가운데 흰색 원 그리기
                let dotRadius = min(size.width, size.height) * centerDotRatio / 2
                let dotRect = CGRect(
                    x: (size.width - dotRadius * 2) / 2,
                    y: (size.height - dotRadius * 2) / 2,
                    width: dotRadius * 2,
                    height: dotRadius * 2
                )
                
                cgContext.setFillColor(centerDotColor.cgColor)
                cgContext.fillEllipse(in: dotRect)
            }
        }
    }
}

