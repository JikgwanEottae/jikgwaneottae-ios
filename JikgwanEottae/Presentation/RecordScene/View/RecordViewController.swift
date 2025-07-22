//
//  RecordViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

final class RecordViewController: UIViewController {

    // MARK: - Property
    
    private let recordView = RecordView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = recordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarButtonItem()
    }
    
    private func configureNavBarButtonItem() {
        self.navigationItem.leftBarButtonItem = recordView.leftBarButtonItem
    }


}
