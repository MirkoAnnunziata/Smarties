//
//  ViewController.swift
//  SPark
//


import UIKit
import SKMaps

class ViewController: UIViewController, SKMapViewDelegate, SKRoutingDelegate, SKNavigationDelegate, SKCalloutViewDelegate {

    var mapView: SKMapView!
    
    let serverURL = "http://192.168.0.2:8888/serverTest/test.php"
    
    var parkingList:ParkingList!
    
    var destinationCoordinate:CLLocationCoordinate2D!
    
    var infoView:TopInfoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupMap()
        NetworkManager.shared.loadParkings(serverURL: serverURL, coordinate: SKPositionerService.sharedInstance().currentCoordinate) { (parkingList, error) in
            guard error == nil else{
                return
            }
            self.parkingList = parkingList!
            
            self.addAnnotation(parkingList: self.parkingList)
        }
        
        self.configureRouteAudioPlayer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AudioService.sharedInstance().cancel()
        SKRoutingService.sharedInstance().stopNavigation()
        SKRoutingService.sharedInstance().clearCurrentRoutes()
    }
    
    func mapView(_ mapView:SKMapView, didSelect annotation:SKAnnotation) {
        let point:CGPoint = CGPoint(x: 0, y: 30.0)
        mapView.showCallout(for: annotation, withOffset: point, animated: true);
        
    }
    func startNavigationButton(_:UIButton){
        self.startNavigation()
    }

    
    func mapView(_ mapView: SKMapView, calloutViewFor annotation: SKAnnotation) -> UIView? {
        let calloutView = CalloutView(frame: CGRect(x: 50, y: 75, width: 0, height: 0))
        calloutView.navigationButton.addTarget(self, action: #selector(self.startNavigationButton(_:)), for: .touchUpInside)
        self.destinationCoordinate = annotation.location
        calloutView.animate(annotation: annotation)
        return calloutView
    }
    
    func mapView(_ mapView: SKMapView, didChangeTo region:SKCoordinateRegion) {
    }
    
    func mapView(_ mapView: SKMapView, didTapAt coordinate:CLLocationCoordinate2D) {
        mapView.hideCallout()
        
    }
    func mapView(_ mapView: SKMapView, didRotateWithAngle angle: Float) {
    }
    
    func setupMap(){

        mapView = SKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        
        mapView.settings.followUserPosition = true;
        
        mapView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.view.addSubview(mapView)
        //show the compass
        mapView.settings.showCompass = false
        //hide the map scale
        mapView.mapScaleView.isHidden = true
        
        let region = SKCoordinateRegion(center: SKPositionerService.sharedInstance().currentCoordinate, zoomLevel: 15)
        self.mapView.settings.displayMode = SKMapDisplayMode.mode2D
        self.mapView.settings.annotationTapZoomLimit = 0
        self.mapView.settings.zoomLimits = .init(mapZoomLimitMin: 5, mapZoomLimitMax: 20)
        
//        self.mapView.addSubview(UILabel(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: 250)))
        mapView.visibleRegion = region
        
        
    }
    
    func addAnnotation(parkingList:ParkingList){
        
        self.mapView.calloutView.delegate = self
        let animationSettings:SKAnimationSettings = SKAnimationSettings()
        
        for parking in parkingList.parkings {
            for spot in parking.spotList {
                let latitude = spot.latitude
                let longitude = spot.longitude

                let coloredView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60.0, height: 60.0))
                coloredView.image = UIImage(named: "verde")
  
                let view = SKAnnotationView(view: coloredView, reuseIdentifier: "viewID")

                let viewAnnotation = SKAnnotation()

                viewAnnotation.annotationView = view
                viewAnnotation.identifier = spot.id
                viewAnnotation.location = CLLocationCoordinate2DMake(latitude, longitude)
  
                mapView.addAnnotation(viewAnnotation, with: animationSettings)
            }
        }
    }

    
        //MARK: SKRoutingService delegate - Routing

    func startNavigation(){

        SKRoutingService.sharedInstance().routingDelegate = self
        SKRoutingService.sharedInstance().navigationDelegate = self
        SKRoutingService.sharedInstance().mapView = mapView
        
        let route = SKRouteSettings()
        let startCoordinate = SKPositionerService.sharedInstance().currentCoordinate
        route.startCoordinate = CLLocationCoordinate2DMake(startCoordinate.latitude, startCoordinate.longitude)
        
        route.destinationCoordinate = self.destinationCoordinate
        print(route.startCoordinate, route.destinationCoordinate)
        
        route.shouldBeRendered = true
        SKRoutingService.sharedInstance().calculateRoute(route)
        
        self.infoView = TopInfoView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.width, height: 50))
        self.mapView.addSubview(infoView)
    }
    
    func configureRouteAudioPlayer(){
        let mainBundlePath:String = Bundle.main.resourcePath! + ("/SKAdvisorResources.bundle")
        let advisorResourcesBundle:Bundle = Bundle(path: mainBundlePath)!
        let soundFileFolder:String = advisorResourcesBundle.path(forResource: "Languages", ofType: "")!
        let currentLanguage:String = "en_us"
        let audioFileFolderPath:String = soundFileFolder + "/" + currentLanguage + "/" + "sound_files"
        
        AudioService.sharedInstance().audioFilesFolderPath =  audioFileFolderPath
        let routeAudio = SKAdvisorSettings()
        routeAudio.advisorVoice = currentLanguage
        SKRoutingService.sharedInstance().advisorConfigurationSettings = routeAudio
        
        
    }
    
    func routingService(_ routingService: SKRoutingService!, didFinishRouteCalculationWithInfo routeInformation: SKRouteInformation!) {
        routingService.zoomToRoute(with: .zero, duration: 10)
        
        let navSettings = SKNavigationSettings()
        navSettings.navigationType = SKNavigationType.simulation
        navSettings.distanceFormat = SKDistanceFormat.metric
        navSettings.showStreetNamePopUpsOnRoute = true
        SKRoutingService.sharedInstance().mapView?.settings.displayMode = SKMapDisplayMode.mode3D
        SKRoutingService.sharedInstance().startNavigation(with: navSettings)
    }
    

    func routingService(_ routingService: SKRoutingService!, didFailWith errorCode: SKRoutingErrorCode) {
        print("Route calculation failed.")
    }
    
    
    //MARK: SKRoutingService delegate - Navigation
    
    func routingService(_ routingService: SKRoutingService!, didChangeDistanceToDestination distance: Int32, withFormattedDistance formattedDistance: String!) {
        let distance = "distanceToDestination " + formattedDistance
        print(distance)
    }
    
    func routingService(_ routingService: SKRoutingService!, didChangeEstimatedTimeToDestination time: Int32) {
        print("timeToDestination " + String(time))
    }
    
    func routingService(_ routingService: SKRoutingService!, didChangeCurrentStreetName currentStreetName: String!, streetType: SKStreetType, countryCode: String!) {
        let streetTypeString: String = String(streetType.rawValue)
        let sentence: String = "Current street name changed to name=" + currentStreetName + " type=" + streetTypeString + " countryCode=" + countryCode
        print(sentence)
        self.infoView.currentStreetName.text = currentStreetName
    }
    
    func routingService(_ routingService: SKRoutingService!, didChangeNextStreetName nextStreetName: String!, streetType: SKStreetType, countryCode: String!) {
        let streetTypeString: String = String(streetType.rawValue)
        let sentence: String = "Next street name changed to name=" + nextStreetName + " type=" + streetTypeString + " countryCode=" + countryCode
        print(sentence)
        self.infoView.nextStreetName.text = nextStreetName
    }
    
    func routingService(_ routingService: SKRoutingService!, didChangeCurrentAdviceImage adviceImage: UIImage!, withLastAdvice isLastAdvice: Bool) {
        print("Current visual advice image changed.")
    }
    
    func routingService(_ routingService: SKRoutingService!, didChangeCurrentVisualAdviceDistance distance: Int32, withFormattedDistance formattedDistance: String!) {
        let sentence: String = "Current visual advice distance changed to distance=" + formattedDistance
        print(sentence)
        self.infoView.distance.text = formattedDistance
    }
    
    func routingService(_ routingService: SKRoutingService!, didChangeSecondaryAdviceImage adviceImage: UIImage!, withLastAdvice isLastAdvice: Bool) {
        print("Secondary visual advice image changed.")
    }
    
    
    func routingService(_ routingService: SKRoutingService!, didChangeSecondaryVisualAdviceDistance distance: Int32, withFormattedDistance formattedDistance: String!) {
        let sentence: String = "Secondary visual advice distance changed to distance=" + formattedDistance
        print(sentence)
    }
    
    func routingService(_ routingService: SKRoutingService!, didUpdateFilteredAudioAdvices audioAdvices: [Any]!) {
        AudioService.sharedInstance().play(audioFiles: audioAdvices as! Array<String>)
    }
    
    func routingService(_ routingService: SKRoutingService!, didUpdateUnfilteredAudioAdvices audioAdvices: [Any]!, withDistance distance: Int32) {
        print("Unfiltered audio advice updated.")
    }
    
    func routingService(_ routingService: SKRoutingService!, didChangeCurrentSpeed speed: Double) {
        let speedString: String = "Current speed: " + String(format:"%.2f", speed)
        print(speedString)
    }
    
    func routingService(_ routingService: SKRoutingService!, didChangeCurrentSpeedLimit speedLimit: Double) {
        let speedString: String = "Current speedlimit: " + String(format:"%.2f", speedLimit)
        print(speedString)
    }
    
    func routingServiceDidStartRerouting(_ routingService: SKRoutingService!) {
        print("Rerouting started.")
    }
    
    func routingService(_ routingService: SKRoutingService!, didUpdateSpeedWarningToStatus speedWarningIsActive: Bool, withAudioWarnings audioWarnings: [Any]!, insideCity isInsideCity: Bool) {
        print("Speed warning status updated.")
    }
    
    func routingServiceDidReachDestination(_ routingService: SKRoutingService!) {
        let message: String? = NSLocalizedString("navigation_screen_destination_reached_alert_message", comment: "")
        let cancelButtonTitle: String? = NSLocalizedString("navigation_screen_destination_reached_alert_ok_button_title", comment: "")
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.mapView.hideCallout()
    }
    
    // MARK: Navigation manager delegate
    
    // TODO: gsp authorization

}

