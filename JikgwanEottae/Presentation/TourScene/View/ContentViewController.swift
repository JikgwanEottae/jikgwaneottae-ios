//
//  ContentViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/21/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

// MARK: - 플로팅 패널 뷰 컨트롤러에 들어갈 컨텐츠 뷰 컨트롤러입니다.

//struct TourPlace {
//    let imageURL: String
//    let title: String
//    let address: String
//    let distance: Double
//}

//final class ContentViewController: UIViewController {
//    // 관광 아이템을 보여줄 테이블 뷰입니다.
//    public let tourPlaceTableView = UITableView().then {
//        $0.register(TourPlaceTableViewCell.self, forCellReuseIdentifier: TourPlaceTableViewCell.ID)
//        $0.rowHeight = 100
//        $0.alwaysBounceVertical = false
//        $0.showsVerticalScrollIndicator = false
//        $0.separatorStyle = .none
//    }
//    
//    // 더미 데이터를 담을 BehaviorRelay
//    private let tourPlaces = BehaviorRelay<[TourPlace]>(value: [])
//    private let disposeBag = DisposeBag()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        hideBackBarButtonItem()
//        setupUI()
//        setupLayout()
//        setupDummyData()
//        bindTableView()
//    }
//    
//    private func setupUI() {
//        self.view.backgroundColor = .white
//        self.view.addSubview(tourPlaceTableView)
//    }
//    
//    private func setupLayout() {
//        tourPlaceTableView.snp.makeConstraints { make in
//            make.top
//                .equalTo(view.safeAreaLayoutGuide)
//            make.leading.trailing
//                .equalToSuperview()
//                .inset(11)
//            make.bottom
//                .equalToSuperview()
//        }
//    }
//    
//    /// 더미 데이터를 설정합니다.
//    private func setupDummyData() {
//        let dummyData = [
//            TourPlace(imageURL: "https://i.namu.wiki/i/VTh_gRv3syQ97ePWTgr86Dib0q1WvfLCDSDtrM8kU13wvv2xIkBaTuhXQP_RnfeZO731KKjZ6Fmz78MsoKSHqP_IwTJ1VjqTWUjTNjKrY01ejHIiNeOsQ9qRPMg3JI-DndZKjNbxkou2oPhuENQ_Kg.webp", title: "경복궁", address: "서울 종로구 사직로 161", distance: 56),
//            TourPlace(imageURL: "https://i.namu.wiki/i/C1NmdoMURjccaBTjbPYwFeMeblCzUAiKCoSBfXC0CO4b7R8C9QSYQ1PPNgrxKVjxt29tdT5k28i3MF1AKutHBmScQEI0tMxO5a9IbTcNnEagabxim5WbAHAMUIDKWH7SXNDQktmawOOZLknaeUwMuA.webp", title: "남산타워", address: "서울 용산구 남산공원길 105", distance: 125),
//            TourPlace(imageURL: "https://i.namu.wiki/i/S09i5N2Rp5H7wGBz4_GHXt_sA3-eoZHsTRKQE2wbTrXbZlQKckAPY8JyDTeOzgwD80rnsBYpUcAVaf4Fj0ht7egNSbmUu0O44WGu5Q_iQ3BHzm1-V9O_yz7goPJ0_h-p-tNKwtDcyrHDvfuUfVMQ_Q.webp", title: "명동성당", address: "서울 중구 명동길 74", distance: 340),
//            TourPlace(imageURL: "https://i.namu.wiki/i/Z-SOF5Xf94L_pwqy-QiG4TXcNG8uIA9ltryBIh4LuFN8B3SxBrkKgT6aLcPPWf_z1TlCzn1XgXqLNFFDebUMVr1dhEy9IMOJ-n9LO3ckm-h2dYMTSqGywHSfC5afLaWlRjeERXjanQElXuQgfoPYog.webp", title: "동대문디자인플라자", address: "서울 중구 을지로 281", distance: 89),
//            TourPlace(imageURL: "https://i.namu.wiki/i/-90b0KLN-KFPjpQiovklmLkP0eIgTHGdAlUhtvqGghDcHmbVsogG_rqnpK5SDwlPDczPe0vgtxBUfNYEz1oTkKnnxpU_ZAjoaqrXMvvKiAkeg7NJ-DcDbvdF4dtCL2ycTCopaAAu6Uk0ZowkyzD0wg.webp", title: "청계천", address: "서울 종로구 청계천로", distance: 200),
//            TourPlace(imageURL: "https://i.namu.wiki/i/W5VpcPxh5lKHo37deae8SgYBF-_3hbWYEW6rxU_4AG0sS95UV2RYjFHanUoG9UKI8XsC94UTUmdrT3HNCory35V4Oi2J-x8BurrlZXDxaC2wC2VQ-nf8hc-fM-GzxIsJ-oejmUKrSvWcjmXICeJTFQ.webp", title: "홍대 걷고싶은거리", address: "서울 마포구 어울마당로", distance: 450),
//            TourPlace(imageURL: "https://i.namu.wiki/i/M70If-dhzysjgI266fW3GGODVvzqM0UBDzfr2W3C2hMqAfspEPxDFZnsuXC0dplRnTclPSiMGp9lrQRTa_wYbmbqc0gvSMohCc83jgGluHAhneub8FjQjAEI1aoymIbDUmw1ijeUxUqfWS9dhnqDfQ.webp", title: "이태원 경리단길", address: "서울 용산구 이태원로", distance: 380),
//            TourPlace(imageURL: "https://i.namu.wiki/i/cE_JRZTD-X_L4xTcgxrqrZ4IJK9IP3p_Ev5qc40H9gMYvoOOLyofOLL7MtCNMv3oLJuJokF2MudqnX0bq80okHumkDlJKPwW7EFJF2YaxWo5w2jipEiUdQimhVAE_n_9scDO-sInLZeiVTaQT4fPFA.webp", title: "강남역 지하상가", address: "서울 강남구 강남대로 지하", distance: 720),
//            TourPlace(imageURL: "https://i.namu.wiki/i/IZiF9GD_mWpwZSQgBAhh_P3ZC7xZjNhzungOohOFAKK7IK8NwRFY-PM8-mxDpYqcsr6CgiuaBaWHMvmTlh91iHtVEH8DbuKTialTGmd5WH2Hg7JuJiKURASyOu7C96ycdBxGGayNPmevOTQDhLHmPg.webp", title: "북촌한옥마을", address: "서울 종로구 계동길 37", distance: 95),
//            TourPlace(imageURL: "https://i.namu.wiki/i/eiBW71ajrm6irLdgVKPKnYbV6t3y1_F5bJDAGrvJOH8e4BhD6Z12O26pQ0l4UKt8BRR--HzEAs_v_svDqE_uA0Q-UNxvzeN99ljMci58cccTw8HYG6v1B9XRqYVHbY-EdXXTp8F2Rc-NsQb2E3FtOA.webp", title: "광장시장 빈대떡골목", address: "서울 종로구 창경궁로 88", distance: 156),
//            TourPlace(imageURL: "https://i.namu.wiki/i/i0f31Ntm_6Lrsc3aOzFoWSs0IDkszlVEnrMBjunyYIgWaa_CN0fFNzXwBlwfBK83BqaAg6J8Qdseh8iAoEaz7WqZkU6y7_2yUreiPXivFUqhuAuTL337zJvL5Pz6bLXsuf_GhV44Cy8-c3Zeknk9fQ.webp", title: "한강공원 반포지구", address: "서울 서초구 신반포로 11", distance: 890),
//            TourPlace(imageURL: "https://i.namu.wiki/i/oiWcq1yxVk0Y4ZhHfMxuwVpH8f89-1_M76YIoN5a2vnqbs9IgjXENv3SJfGf5h7LBMATZmWh3CjmnUw2TlLQLGhvb6FigAE5DQEdQVfhZz7Uud04WSt73i0IXaIv3Au0RQ0mwxMpbjQ9sJCEyq1eJg.webp", title: "용산전자상가", address: "서울 용산구 한강대로23길 55", distance: 420),
//            TourPlace(imageURL: "https://i.namu.wiki/i/aJ9Y9E2NYUoaxgloUq4jXlA1W8L8WDOUHfM-20lboc_0jaMk2R6oTpZYejCMYqalXwEi4sPdon7PRyWcp5At5NBnvHgVlTgWtHnB0vOAuPG-Uxx4JA7FpofFopeU9EIv8vG9oInAwNCQqzeFj5QgOQ.webp", title: "홍릉수목원", address: "서울 동대문구 회기로 57", distance: 650)
//        ]
//        tourPlaces.accept(dummyData)
//    }
//    
//    /// 뷰 컨트롤러를 테이블 뷰와 바인딩합니다.
//    private func bindTableView() {
//        tourPlaces
//            .bind(
//                to: tourPlaceTableView.rx.items(
//                    cellIdentifier: TourPlaceTableViewCell.ID,
//                    cellType: TourPlaceTableViewCell.self
//                )
//            ) { indexPath, tourPlace, cell in
//                cell.configure(
//                    thumbnail: tourPlace.imageURL,
//                    title: tourPlace.title,
//                    address: tourPlace.address,
//                    distance: tourPlace.distance
//                )
//            }
//            .disposed(by: disposeBag)
//        
//        tourPlaceTableView.rx.modelSelected(TourPlace.self)
//            .subscribe { tourPlace in
//                let vc = UIViewController()
//                vc.view.backgroundColor = .white
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
//    }
//}
