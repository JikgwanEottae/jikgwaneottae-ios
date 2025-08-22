//
//  TourViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/18/25.
//

import UIKit

import FloatingPanel
import KakaoMapsSDK
import RxSwift
import RxCocoa

final class TourViewController: UIViewController {
    private let tourView = TourView()
    private let team: KBOTeam
    // Kakao Map
    private var mapController: KMController?
    private let poiLayerID = "PoiLayer"
    private let poiStyleID = "PoiStyle"
    // Floating Panel
//    private var floatingPanelController: FloatingPanelController!
    private let disposeBag = DisposeBag()
        
    init(team: KBOTeam) {
        self.team = team
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = tourView
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = team.ballpark
        mapController = KMController(viewContainer: tourView.mapContainer)
        mapController!.delegate = self
        //엔진 초기화, 엔진 내부 객체 생성 및 초기화가 진행됩니다.
        mapController?.prepareEngine()
//        setupFloatingPanel()
        recenterButtonTapped()
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
//        floatingPanelController.removePanelFromParent(animated: false)
    }
    
    /// recenter 버튼이 클릭됬을 때 이벤트입니다.
    private func recenterButtonTapped() {
        self.tourView.recenterButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.resetToInitialLocation()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Kakao Map extension

extension TourViewController: MapControllerDelegate, KakaoMapEventDelegate, FloatingPanelControllerDelegate {
    func addViews() {
        let defaultPosition = MapPoint(
            longitude: team.coordinate.longitude,
            latitude: team.coordinate.latitude
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
        let mapView = mapController?.getView("mapview") as! KakaoMap
        mapView.viewRect = tourView.mapContainer.bounds
        // 카메라의 최소 줌 레벨입니다.
        mapView.cameraMinLevel = 13
        createLabelLayer(on: mapView)
        createPoiStyle(on: mapView)
        createPoi(
            on: mapView,
            longitude: team.coordinate.longitude,
            latitude: team.coordinate.latitude
        )
        // 지도의 카카오 로고 위치를 변경합니다.
        mapView.setLogoPosition(
            origin: GuiAlignment(
                vAlign: .bottom,
                hAlign: .left
            ),
            position: CGPoint(
                x: 38.0,
                y: 30.0
            )
        )
        // 틸트 기능을 제거합니다.
        mapView.setGestureEnable(type: .tilt, enable: false)
        // 회전 기능을 제거합니다.
        mapView.setGestureEnable(type: .rotate, enable: false)
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
    /// LabelManager를 통해 Layer를 생성합니다.
    private func createLabelLayer(on mapView: KakaoMap) {
        // LabelManager를 가져옵니다.
        // LabelLayer는 LabelManger를 통해 추가할 수 있습니다.
        let labelManager = mapView.getLabelManager()
        //
        let layerOption = LabelLayerOptions(
            layerID: poiLayerID,
            competitionType: .none,
            competitionUnit: .symbolFirst,
            orderType: .rank,
            zOrder: 10001
        )
        let _ = labelManager.addLabelLayer(option: layerOption)
    }
    
    /// Poi 스타일을 생성합니다.
    /// Poi를 생성하기 위해서는 먼저 LabelLayer를 생성해야 합니다.
    private func createPoiStyle(on mapView: KakaoMap) {
        let labelManager = mapView.getLabelManager()
        
        let symbolImage = UIImage(systemName: "pin.fill")?
            .withTintColor(.tossRedColor, renderingMode: .alwaysOriginal)

        // 심볼을 지정합니다.
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
    
    /// 위도 및 경도의 좌표를 입력받고, Poi를 생성합니다.
    private func createPoi(on mapView: KakaoMap, longitude: Double, latitude: Double) {
        let labelManager = mapView.getLabelManager()
        guard let layer = labelManager.getLabelLayer(layerID: poiLayerID) else { return }
        let poiOption = PoiOptions(styleID: poiStyleID)
        let poiCoordiate = MapPoint(
            longitude: longitude,
            latitude: latitude
        )
        let poi = layer.addPoi(
            option:poiOption,
            at: poiCoordiate
        )
        poi?.show()
    }
    
    /// 카메라의 이동이 멈췄을 때 호출되는 델리게이트입니다.
    func cameraDidStopped(kakaoMap: KakaoMap, by: MoveBy) {
        // 지도의 중심 좌표입니다.
        let center = kakaoMap.getPosition(
            CGPoint(
                x: kakaoMap.viewRect.width * 0.5,
                y: kakaoMap.viewRect.size.height * 0.5
            )
        )
        print("위도: \(center.wgsCoord.latitude), 경도: \(center.wgsCoord.longitude)" )
    }
    
    
    
}


extension TourViewController {
//    /// 플로팅 패널의 초기 상태를 설정합니다.
//    private func setupFloatingPanel() {
//        self.floatingPanelController = FloatingPanelController()
//        self.floatingPanelController.layout = CustomFloatingPanelLayout()
//        self.floatingPanelController.surfaceView.appearance = createFloatingPanelApperance()
//        self.floatingPanelController.backdropView.dismissalTapGestureRecognizer.isEnabled = false
//        // 아래로 스와이프 닫기를 비활성화합니다.
//        self.floatingPanelController.isRemovalInteractionEnabled = false
//        // floating panel에 들어갈 뷰 컨트롤러입니다.
//        let contentViewController = ContentViewController()
//        let navigationController = UINavigationController(rootViewController: contentViewController)
//        navigationController.configureBarAppearnace()
//        self.floatingPanelController.set(contentViewController: navigationController)
//        self.floatingPanelController.track(scrollView: contentViewController.tourPlaceTableView)
//        self.floatingPanelController.addPanel(toParent: self)
//        self.floatingPanelController.invalidateLayout()
//    }
//    
//    /// 플로팅 패널의 Appearance를 생성합니다.
//    private func createFloatingPanelApperance() -> SurfaceAppearance {
//        // 패널에 적용할 appearance를 설정합니다.
//        let appearance = SurfaceAppearance()
//        appearance.cornerRadius = 17
//        appearance.backgroundColor = .white
//        // 패널 둘레에 적용할 그림자를 설정합니다.
//        let shadow = SurfaceAppearance.Shadow()
//        shadow.color = UIColor.gray
//        shadow.radius = 5
//        shadow.spread = 5
//        appearance.shadows = [shadow]
//        return appearance
//    }
}

extension TourViewController {
    /// 초기 위치로 지도를 이동시킵니다.
    private func resetToInitialLocation() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let cameraUpdate = CameraUpdate.make(
            target: MapPoint(
                longitude: team.coordinate.longitude,
                latitude: team.coordinate.latitude
            ),
            mapView: mapView
        )
        mapView.animateCamera(
            cameraUpdate: cameraUpdate,
            options: CameraAnimationOptions(
                autoElevation: false,
                consecutive: false,
                durationInMillis: 100
            )
        )
    }
}
