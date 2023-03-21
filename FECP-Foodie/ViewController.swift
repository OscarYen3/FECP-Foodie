//
//  ViewController.swift
//  FECP-Foodie
//
//  Created by OscarYen on 2023/3/7.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager  = CLLocationManager()
    let regionInMeters : Double = 300
    
    var artwork1 = Artwork(title: "忠義山步道",locationName: "北投區",coordinate:
        CLLocationCoordinate2D(latitude:25.137000, longitude: 121.478639))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fixNavigationBar()
        cheaklocationServices()
        mapView.userTrackingMode = .follow
        mapView.delegate = self
        mapView.addAnnotation(artwork1)
        setLocationManager()
    }
   
    func cheaklocationServices(){
//        CLLocationManager.locationServicesEnabled()
        cheakLocationAuthorzation()
    }
    
    func setLocationManager() {
        locationManager.requestWhenInUseAuthorization()             //尋求使用者是否授權APP得知位置
        locationManager.delegate = self                             //若是user有移動，可以將透過delegate知道位置顯示
        locationManager.desiredAccuracy = kCLLocationAccuracyBest   //user位置追蹤精確程度，設置成最精確位置
        locationManager.activityType = .automotiveNavigation        //設定使用者的位置模式，手機會去依照不同設定做不同的電力控制
        locationManager.startUpdatingLocation()
    }
    
    func cheakLocationAuthorzation(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            //locationManager.stopUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        case .denied:
            break
        @unknown default:
            break
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center:location,latitudinalMeters:regionInMeters,longitudinalMeters:regionInMeters)
            mapView.setRegion(region, animated: true)
            print(location.latitude,location.longitude)
        }
    }
    
    func fixNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.darkGray
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
            navigationItem.compactAppearance = appearance
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location:CLLocation = locations.last else { return }
        print("Lat:\(location.coordinate.latitude) Lon:\(location.coordinate.longitude)")
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center:center,latitudinalMeters: regionInMeters,longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        //            locationManager.distanceFilter = CLLocationDistance(10); //表示移動10公尺再更新座標資訊
      // var distance:CLLocationDistance = location.distanceFromLocation(artwork1)
    // print("两点间距离是：\(distance)")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        cheakLocationAuthorzation()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Artwork else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

