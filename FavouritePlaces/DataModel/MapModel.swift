//
//  MapModel.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 4/5/2023.
//

import Foundation
import MapKit

/// MapModel loads an interactive map for user viewing.
/// MapModel extends functionality to enable map interactivity in the ViewMapModel.
/// - Parameters
///     - address : String
///     - latitude : Double
///     - longitude : Double
///     - delta : Double
///     - region : MKCoordinateRegion
class MapModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var address = ""         //address stores the locations address
    @Published var latitude = 0.0       //latitude stores the locations latitude coordinate
    @Published var longitude = 0.0      //longitude stores the location longitude coordinate
    @Published var delta = 100.00       //Delta stores the zoom level of the map.
    //region stores the area the location is in based on the lat/long.
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
    )
    
    //Shares map model for use on views/swiftUI.
    static let shared = MapModel()
    
}
