//
//  HomeViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - Property
    
    private let homeView = HomeView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBarButtonItem()
    }
    
    private func configureNaviBarButtonItem() {
        let leftBarButtonItem = UIBarButtonItem(customView: homeView.titleLabel)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    

}
