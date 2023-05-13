//
//  MapModel.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 4/5/2023.
//

import Foundation
import MapKit

class MapModel: ObservableObject {
    @Published var address = ""
    @Published var latitude = 0.0
    @Published var longitude = 0.0
    @Published var delta = 100.00
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0)
    )
    
    static let shared = MapModel()
    
    init() {
        
    }
    
    
}
