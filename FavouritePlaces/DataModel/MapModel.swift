//
//  MapModel.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 4/5/2023.
//

import Foundation
import MapKit

var lattitude = 0.0
var longitude = 0.0
var rangeMeter = 10_000.00

class MapModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: lattitude, longitude: longitude),
        latitudinalMeters: rangeMeter,
        longitudinalMeters: rangeMeter
    )
    
}
