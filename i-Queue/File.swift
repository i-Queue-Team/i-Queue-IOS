//
//  File.swift
//  i-Queue
//
//  Created by A4-iMAC09 on 4/6/21.
//

import UIKit
import MapKit
import Contacts

class Artwork: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D

    init(title:String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        self.locationName = locationName
        self.discipline = discipline
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    //Abrir aplicacion maps al tocar accesorio del annotation
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placeMark)
        
        mapItem.name = title
        
        return mapItem
    }
    
}
