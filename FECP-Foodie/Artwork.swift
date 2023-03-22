//
//  MyMap.swift
//  Hiking
//
//  Created by OscarYen on 2018/12/20.
//  Copyright © 2018 OscarYen. All rights reserved.
//

import Foundation
import MapKit
import Contacts


class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    
    init(title: String?, locationName: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
//    var locationName1  = ["北投區","文山區","內湖區","信義區","士林區","中山區","南港區"]
//    var title1  = ["忠義山步道","下青礐步道","郵政訓練所步道","中正山親山步道","軍艦岩步道","水尾巴拉卡步道","泉源里紗帽步道"]
//    var title2  = ["仙跡岩步道1號路線","仙跡岩步道2號路線" ,"仙跡岩步道試院支線","仙跡岩步道麥田支線","指南宮步道","飛龍步道","樟樹步道","樟湖步道","猴山岳步道"]
//    var title3  = ["大崙頭山步道","金面山步道","忠勇山步道","忠勇山越嶺步道","龍船岩步道","鯉魚山步道","圓覺寺步道","大溝溪畔步道", "碧湖步道","白鷺鷥山步道"]
//    var title4  = ["拇指山步道","虎山奉天宮步道","虎山120高地步道","虎山吉福宮步道","虎山生態步道","虎山自然步道","虎山山腰步道","虎山溪步道",
//                   "象山永春崗步道","象山北星寶宮步道","象山一線天步道"]
//    var title5 = ["水管路步道","下竹林步道","婆婆橋步道","大崙頭山森林步道","大崙頭山自然步道"]
//    var title6  = ["劍潭山步道主線","劍潭山步道劍潭公園副線"]
//    var title7  = ["示範茶廠環山步道","桂花吊橋步道","更寮步道","栳寮步道","中華技術學院步道","九五峰步道"]
    
    var subtitle: String? {
        return locationName
    }

    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork 
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
