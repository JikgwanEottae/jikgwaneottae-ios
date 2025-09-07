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
        doneTitle: String = "확인",
        cancelTitle: String? = nil,
        preferredStyle: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle)
        let doneAction = UIAlertAction(
            title: doneTitle,
            style: .default
        ) { _ in
            completion?()
        }
        alert.addAction(doneAction)
        if let cancelTitle = cancelTitle {
            let cancelAction = UIAlertAction(
                title: cancelTitle,
                style: .cancel
            )
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true)
    }
}
