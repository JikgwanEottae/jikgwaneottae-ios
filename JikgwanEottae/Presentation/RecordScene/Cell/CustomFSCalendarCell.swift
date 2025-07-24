//
//  CustomFSCalendarCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/24/25.
//

import Foundation

import FSCalendar

final class CustomFSCalendarCell: FSCalendarCell {
    static let ID = "CustomFSCalendarCell"
    private let selectionDiameter: CGFloat = 30
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titleCenter = titleLabel.center
        let d = selectionDiameter
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: d, height: d)
        shapeLayer.cornerRadius = d / 2
        shapeLayer.position = titleCenter
        let path = UIBezierPath(
            roundedRect: shapeLayer.bounds,
            cornerRadius: d / 2
        ).cgPath
        if shapeLayer.path !== path {
            shapeLayer.path = path
        }
    }
}
