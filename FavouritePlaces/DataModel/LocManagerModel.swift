//
//  LocManagerModel.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 24/5/2023.
//

import Foundation
import MapKit
import CoreLocation

class LocManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    var region = MKCoordinateRegion()
    
    let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        region.span.longitudeDelta = 100.0
        region.span.latitudeDelta = 100.0
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map{
            region.center.latitude = $0.coordinate.latitude
            region.center.longitude = $0.coordinate.longitude
            print("lat: \($0.coordinate.latitude), long: \($0.coordinate.longitude)")
        }
    }
}
