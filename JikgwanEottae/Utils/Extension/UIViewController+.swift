//
//  UIViewController+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/26/25.
//

import UIKit

extension UIViewController {
    /// 네비게이션 바의 백 버튼 아이템을 공백으로 설정합니다.
    func hideBackBarButtonItem() {
        let backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    /// 탭 이벤트가 발생할 경우 키보드를 내립니다.
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIGestureRecognizerDelegate extension

extension UIViewController: UIGestureRecognizerDelegate {
    // 탭 제스처가 UIControl 위의 터치를 가로채지 않도록 하기
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        // 만약 터치된 뷰가 UIButton, UISlider, UISwitch, UITextField 등 UIControl 계열이면 false
        if touch.view is UIControl {
            // 제스처를 무시
            return false
        }
        return true
    }
}

extension UIViewController {
    /// 알람 화면을 표시합니다.
    func showAlert(
        title: String,
        message: String? = nil,
        doneTitle: String,
        doneStyle: UIAlertAction.Style = .default,
        cancelTitle: String? = nil,
        cancelStyle: UIAlertAction.Style = .cancel,
        preferredStyle: UIAlertController.Style = .alert,
        doneCompletion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: preferredStyle)
        // 타이틀의 폰트를 설정합니다.
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont.gMarketSans(size: 16, family: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.primaryTextColor
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        // 메시지가 있을 경우 메시지의 폰트를 설정합니다.
        if let message = message {
            let messageAttributes = [
                NSAttributedString.Key.font: UIFont.gMarketSans(size: 12, family: .medium),
                NSAttributedString.Key.foregroundColor: UIColor.tertiaryTextColor
            ]
            let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
        }
        // 확인 버튼의 액션을 설정합니다.
        let doneAction = UIAlertAction(title: doneTitle, style: doneStyle) { _ in
            doneCompletion?()
        }
        alert.addAction(doneAction)
        // 취소 버튼의 액션을 설정합니다.
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: cancelStyle) { _ in
                cancelCompletion?()
            }
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true)
    }
}
