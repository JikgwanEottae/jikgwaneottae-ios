//
//  UIView+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/29/25.
//

import UIKit

extension UIView {
    public func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(
            frame: CGRect(
                x: self.frame.size.width/2 - 120,
                y: self.frame.size.height - 150,
                width: 240,
                height: 40
            )
        )
        toastLabel.text = message
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.pretendard(size: 14, family: .medium)
        toastLabel.backgroundColor = UIColor.Custom.charcoal.withAlphaComponent(0.9)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 14
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        UIView.animate(
            withDuration: 0.4,
            delay: duration - 0.4,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {
                toastLabel.alpha = 0.0
            },
            completion: { (finished) in
                toastLabel.removeFromSuperview()
            }
        )
    }
}
