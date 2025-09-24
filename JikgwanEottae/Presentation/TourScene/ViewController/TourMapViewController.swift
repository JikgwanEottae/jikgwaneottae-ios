//
//  TourMapViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/18/25.
//

import UIKit

import KakaoMapsSDK
import RxSwift
import RxCocoa

final class TourMapViewController: UIViewController {
    private let viewModel: TourMapViewModel
    private let tourMapView = TourMapView()
    private var mapController: KMController?
    private let poiLayerID = "PoiLayer"
    private let poiStyleID = "PoiStyle"
    private var coordinate: Coordinate?
    private let tourTypeRelay = PublishSubject<TourType>()
    private let mapCenterCoordinateRelay = PublishRelay<Coordinate>()
    private let disposeBag = DisposeBag()
        
    init(viewModel: TourMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = tourMapView
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindChipBar()
        bindViewModel()
        setupKakaoMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if mapController?.isEnginePrepared == false {
            mapController?.prepareEngine()
        }
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //렌더링 중지.
        mapController?.pauseEngine()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
        mapController?.resetEngine()
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
    }
    
    /// 카카오 맵 초기 설정입니다.
    private func setupKakaoMap() {
        mapController = KMController(viewContainer: tourMapView.mapContainer)
        mapController!.delegate = self
        //엔진 초기화, 엔진 내부 객체 생성 및 초기화가 진행됩니다.
        mapController?.prepareEngine()
    }
    
    /// 뷰 모델과 바인딩합니다.
    private func bindViewModel() {
        let input = TourMapViewModel.Input(
            tourTypeSelected: tourTypeRelay,
            mapCenterChanged: mapCenterCoordinateRelay,
            centerButtonTapped: tourMapView.centerActionButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.naviTitle
            .drive(onNext: { [weak self] title in
                self?.title = title
            })
            .disposed(by: disposeBag)
        
        output.initialCoordinate
            .drive(onNext: { [weak self] initialCoordinate in
                self?.coordinate = initialCoordinate
            })
            .disposed(by: disposeBag)
        
        output.centerButtonState
            .drive(onNext: { [weak self] isShowMode in
                self?.tourMapView.updateCenterButtonState(isSearchMode: isShowMode)
            })
            .disposed(by: disposeBag)
            
        output.tourPlaces
            .withUnretained(self)
            .subscribe(onNext: { owner, tourPlaces in
                let mapView = owner.mapController?.getView("mapview") as! KakaoMap
                owner.createPois(on: mapView, tourPlaces: tourPlaces)
            })
            .disposed(by: disposeBag)
        
        output.hasMoreData
            .withUnretained(self)
            .subscribe(onNext: { owner, hasMoreData in
                if !hasMoreData {
                    owner.tourMapView.showToast(message: "장소를 모두 가져왔어요")
                }
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.tourMapView.activityIndicator.startAnimating()
                } else {
                    self?.tourMapView.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    /// 칩 바와 바인딩하고, 관광 타입 선택 이벤트를 전달합니다.
    private func bindChipBar() {
        self.tourMapView.categoryChipBar.onChipSelected = { [weak self] selectedIndex in
            let tourType = TourType.allCases[selectedIndex]
            self?.tourTypeRelay.onNext(tourType)
        }
    }
}

// MARK: - Kakao Map extension

extension TourMapViewController: MapControllerDelegate, KakaoMapEventDelegate {
    func addViews() {
        guard let coordinate = coordinate else { return }
        let defaultPosition = MapPoint(
            longitude: coordinate.longitude,
            latitude: coordinate.latitude
        )
        let mapviewInfo = MapviewInfo(
            viewName: "mapview",
            viewInfoName: "map",
            defaultPosition: defaultPosition,
            defaultLevel: 7
        )
        mapController?.addView(mapviewInfo)
    }
    
    /// addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행합니다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        guard let coordinate = coordinate else { return }
        let mapView = mapController?.getView("mapview") as! KakaoMap
        mapView.viewRect = tourMapView.mapContainer.bounds
        // 카메라의 최소 줌 레벨입니다.
        mapView.cameraMinLevel = 13
        createLabelLayer(on: mapView)
        createAllPoiStyles(on: mapView)
        createPoi(
            on: mapView,
            longitude: coordinate.longitude,
            latitude: coordinate.latitude
        )
        // 지도의 카카오 로고 위치를 변경합니다.
        mapView.setLogoPosition(
            origin: GuiAlignment(
                vAlign: .bottom,
                hAlign: .left
            ),
            position: CGPoint(
                x: 35.0,
                y: 20.0
            )
        )
        mapView.setGestureEnable(type: .tilt, enable: false) // 틸트 기능을 제거합니다.
        mapView.setGestureEnable(type: .rotate, enable: false) // 회전 기능을 제거합니다.
        mapView.eventDelegate = self
    }
    
    /// addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행합니다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
    }
    
    /// Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행합니다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        //지도뷰의 크기를 리사이즈된 크기로 지정한다.
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    func viewWillDestroyed(_ view: ViewBase) {
        
    }
    
    @objc func willResignActive() {
        //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
        mapController?.pauseEngine()
    }
    
    @objc func didBecomeActive() {
        //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
        mapController?.activateEngine()
    }
}

extension TourMapViewController {
    /// LabelManager를 통해 Layer를 생성합니다.
    private func createLabelLayer(on mapView: KakaoMap) {
        // LabelManager를 가져옵니다.
        // LabelLayer는 LabelManger를 통해 추가할 수 있습니다.
        let labelManager = mapView.getLabelManager()
        // 초기 좌표 전용 레이어 옵션입니다.
        let defaultLayerOption = LabelLayerOptions(
            layerID: poiLayerID,
            competitionType: .none,
            competitionUnit: .symbolFirst,
            orderType: .rank,
            zOrder: 10005
        )
        let _ = labelManager.addLabelLayer(option: defaultLayerOption)
        // 관광지 좌표 전용 레이어 옵션입니다.
        let tourPlaceLayerOption = LabelLayerOptions(
            layerID: "tourPoiLayerID",
            competitionType: .upperSame,
            competitionUnit: .symbolFirst,
            orderType: .rank,
            zOrder: 10001
        )
        let _ = labelManager.addLabelLayer(option: tourPlaceLayerOption)
    }
    
    /// 모든 Poi 스타일을 한번에 모아서 생성합니다. 주의! 동적 Poi 스타일 생성을 지양합니다.
    private func createAllPoiStyles(on mapView: KakaoMap) {
        let labelManager = mapView.getLabelManager()
        createMarkerPoiStyle(labelManager: labelManager)
        createSinglePoiStyle(labelManager: labelManager)
        for count in 2...99 {
            createNumberPoiStyle(labelManager: labelManager, count: count)
        }
        createLimitPoiStyle(labelManager: labelManager)
    }
    
    /// 초기 위치에 찍을 마커의 Poi 스타일을 생성합니다.
    private func createMarkerPoiStyle(labelManager: LabelManager) {
        let symbolImage = UIImage(named: "marker")
        // 아이콘 스타일을 설정합니다.
        let iconStyle = PoiIconStyle(
            symbol: symbolImage,
            anchorPoint: CGPoint(x: 0.5, y: 1.0)
        )
        // 특정 레벨에 적용될 라벨스타일을 지정합니다.
        let perLevelStyle = PerLevelPoiStyle(
            iconStyle: iconStyle,
            level: 0
        )
        // PoiStyle을 지정합니다.
        let poiStyle = PoiStyle(
            styleID: poiStyleID,
            styles: [perLevelStyle]
        )
        // LabelManager에 Style을 등록합니다.
        labelManager.addPoiStyle(poiStyle)
    }
    
    /// 초기 위치에 찍을 마커의 Poi를 생성합니다.
    private func createPoi(on mapView: KakaoMap, longitude: Double, latitude: Double) {
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: poiLayerID) else { return }
        let poiOption = PoiOptions(styleID: poiStyleID)
        let poiCoordiate = MapPoint(
            longitude: longitude,
            latitude: latitude
        )
        let poi = layer.addPoi(
            option: poiOption,
            at: poiCoordiate
        )
        poi?.show()
    }
    
    /// 번호 아이콘을 가지는 단일 Poi 스타일을 생성합니다.
    private func createSinglePoiStyle(labelManager: LabelManager) {
        let symbolImage = UIImage.circularNumberImage(number: nil)
        // 아이콘 스타일을 설정합니다.
        let iconStyle = PoiIconStyle(
            symbol: symbolImage,
            anchorPoint: CGPoint(x: 0.5, y: 1.0)
        )
        // 폰트 스타일을 설정합니다.
        let textStyle = TextStyle(
            fontSize: 21,
            fontColor: .primaryTextColor,
            font: "PaperLogy-5Medium",
            charSpace: 2
        )
        // 폰트 스타일을 적용하여 PoiTextStyle을 설정합니다.
        let poiTextStyle = PoiTextStyle(textLineStyles: [
            PoiTextLineStyle(textStyle: textStyle)
        ])
        // 특정 레벨에 적용될 라벨스타일을 지정합니다.
        let perLevelStyle = PerLevelPoiStyle(
            iconStyle: iconStyle,
            textStyle: poiTextStyle,
            level: 0
        )
        // PoiStyle을 지정합니다.
        let poiStyle = PoiStyle(
            styleID: "singlePoiStyle",
            styles: [perLevelStyle]
        )
        // LabelManager에 Style을 등록합니다.
        labelManager.addPoiStyle(poiStyle)
    }
    
    /// 같은 위치의 아이템에서 사용할 Poi 스타일을 생성합니다.
    private func createNumberPoiStyle(labelManager: LabelManager, count: Int) {
        let symbolImage = UIImage.circularNumberImage(number: String(count))
        // 아이콘 스타일을 설정합니다.
        let iconStyle = PoiIconStyle(
            symbol: symbolImage,
            anchorPoint: CGPoint(x: 0.5, y: 1.0)
        )
        // 특정 레벨에 적용될 라벨스타일을 지정합니다.
        let perLevelStyle = PerLevelPoiStyle(
            iconStyle: iconStyle,
            level: 0
        )
        // PoiStyle을 지정합니다.
        let poiStyle = PoiStyle(
            styleID: "numberPoiStyle_\(count)",
            styles: [perLevelStyle]
        )
        // LabelManager에 Style을 등록합니다.
        labelManager.addPoiStyle(poiStyle)
    }
    
    /// 같은 위치의 아이템이 99개 이상일 때 사용할 Poi 스타일을 생성합니다.
    private func createLimitPoiStyle(labelManager: LabelManager) {
        let symbolImage = UIImage.circularNumberImage(number: "99+")
        // 아이콘 스타일을 설정합니다.
        let iconStyle = PoiIconStyle(
            symbol: symbolImage,
            anchorPoint: CGPoint(x: 0.5, y: 1.0)
        )
        // 특정 레벨에 적용될 라벨스타일을 지정합니다.
        let perLevelStyle = PerLevelPoiStyle(
            iconStyle: iconStyle,
            level: 0
        )
        // PoiStyle을 지정합니다.
        let poiStyle = PoiStyle(
            styleID: "limitPoiStyle",
            styles: [perLevelStyle]
        )
        // LabelManager에 Style을 등록합니다.
        labelManager.addPoiStyle(poiStyle)
    }
    
    /// 다수의 Poi를 생성합니다.
    private func createPois(on mapView: KakaoMap, tourPlaces: [TourPlace]) {
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: "tourPoiLayerID") else { return }
        layer.clearAllItems()
        let groupedPlaces = Dictionary(grouping: tourPlaces) { place in
            return Coordinate(latitude: place.latitude!, longitude: place.longitude!)
        }
        var poiOptions: [PoiOptions] = []
        var poiMapPoints: [MapPoint] = []
        var groupedPlacesArray: [[TourPlace]] = []
        for (coordinate, places) in groupedPlaces {
            let count = places.count
            
            let poiStyleID: String = {
                switch count {
                case 1:
                    return "singlePoiStyle"
                case 2...99:
                    return "numberPoiStyle_\(count)"
                default:
                    return "limitPoiStyle"
                }
            }()
            let poiOption = PoiOptions(styleID: poiStyleID)
            poiOption.clickable = true
            if count == 1 {
                poiOption.addText(
                    PoiText(
                        text: places[0].title,
                        styleIndex: 0
                    )
                )
            }
            let poiCoordinate = MapPoint(
                longitude: coordinate.longitude,
                latitude: coordinate.latitude
            )
            poiOptions.append(poiOption)
            poiMapPoints.append(poiCoordinate)
            groupedPlacesArray.append(places)
        }
        let pois = layer.addPois(
            options: poiOptions,
            at: poiMapPoints
        )
        guard let pois = pois else { return }
        for (index, poi) in pois.enumerated() {
            let _ = poi.addPoiTappedEventHandler(target: self, handler: TourMapViewController.poiDidTappedHandler)
            poi.userObject = groupedPlacesArray[index] as AnyObject
            poi.show()
        }
    }
}

extension TourMapViewController {
    /// 카메라의 이동이 멈췄을 때 호출되는 델리게이트입니다.
    func cameraDidStopped(kakaoMap: KakaoMap, by: MoveBy) {
        // 지도의 중심 좌표입니다.
        let center = kakaoMap.getPosition(
            CGPoint(
                x: kakaoMap.viewRect.width * 0.5,
                y: kakaoMap.viewRect.size.height * 0.5
            )
        )
        let latitude = center.wgsCoord.latitude
        let longitude = center.wgsCoord.longitude
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)
        self.mapCenterCoordinateRelay.accept(coordinate)
    }
    
    /// Poi가 클릭됬을 때 핸들러입니다.
    private func poiDidTappedHandler(_ param: PoiInteractionEventParam) {
        // Poi에 저장된 아이템 객체를 가져오기
        guard let tourPlaces = param.poiItem.userObject as? [TourPlace] else { return }
        let tourListViewController = TourListViewController(tourPlaces: tourPlaces)
        if let sheet = tourListViewController.sheetPresentationController {
            sheet.selectedDetentIdentifier = .medium
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        self.present(tourListViewController, animated: true)
    }
}
