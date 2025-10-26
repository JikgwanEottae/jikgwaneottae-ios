//
//  TourNearByPlaceViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import UIKit

import RxSwift
import RxCocoa

final class TourNearByPlaceViewController: UIViewController {
    private let tourNearByPlaceView = TourNearByPlaceView()
    private let viewModel: TourNearByPlaceViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: TourNearByPlaceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = tourNearByPlaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = TourNearByPlaceViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.stadium
            .drive(onNext: { [weak self] stadium in
                guard let self = self else { return }
                self.title = stadium
            })
            .disposed(by: disposeBag)
        
        output.attractions
            .drive(tourNearByPlaceView.attractionTableView.rx.items(
                cellIdentifier: AttractionCell.ID,
                cellType: AttractionCell.self
            )) { row, attraction, cell in
                cell.configure(with: attraction)
            }
            .disposed(by: disposeBag)
    }
}
