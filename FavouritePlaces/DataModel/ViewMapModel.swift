//
//  MapModelExtension.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 11/5/2023.
//

import Foundation
import CoreLocation
import SwiftUI

/// MapModel extensions for added functionality / methods
extension MapModel {
    //Get and set latitude as a string
    var latStr: String {
        get{String(format: "%.5f", latitude)}
        set{
            guard let lat = Double(newValue), lat <= 90.0, lat >= -90.0 else {return}
            latitude = lat
        }
    }
    //Get and set longitude as a string
    var longStr: String {
        get{String(format: "%.5f", longitude)}
        set{
            guard let long = Double(newValue), long <= 180.0, long >= -180.0 else {return}
            longitude = long
        }
        
    }
    
    //Get longitude and latitude of current map region location
    //Based on where the user is currently looking on the map.
    func updateFromRegion() {
        latitude = region.center.latitude
        longitude = region.center.longitude
    }
    
    //upon loading the screen, user is brought to the saved location with some animation.
    func setupRegion() {
        withAnimation {
            region.center.latitude = latitude
            region.center.longitude = longitude
            region.span.longitudeDelta = delta
            region.span.latitudeDelta = delta
        }
    }
    
    //Gets the address of the current map location through current lat/long coordinates.
    func fromLocationToAddress() {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) {
            marks, error in
            if let err = error {
                print("error in fromLocationToAddress: \(err)")
                return
            }
            let mark = marks?.first
            let name = mark?.name ?? mark?.country ?? mark?.locality ?? mark?.administrativeArea ?? "No Address"
            self.address = name
        }
    }
    
    //Gets the location based on the current address set by the user.
    func fromAddressToLocation () async {
        let encode = CLGeocoder()
        let marks = try? await encode.geocodeAddressString(self.address)
        
        if let mark = marks?.first {
            self.latitude = mark.location?.coordinate.latitude ?? self.latitude
            self.longitude = mark.location?.coordinate.longitude ?? self.longitude
            self.setupRegion()
        }
    }
    
    //Gets the location based on the current address set by the user.
    //This version works with animated move to new location.
    func fromAddressToLocationOld(_ callback: @escaping () -> Void) {
        let encode = CLGeocoder()
        encode.geocodeAddressString(self.address) {
            marks, error in
            if let err = error {
                print("Error in fromAddressToLocation: \(err)")
            }
            if let mark = marks?.first {
                self.latitude = mark.location?.coordinate.latitude ?? self.latitude
                self.longitude = mark.location?.coordinate.longitude ?? self.longitude
                callback()
                self.setupRegion()
            }
        }
    }
    
    //Adjusts the user adjusted zoom level.
    func fromZoomToDelta(_ zoom: Double) {
        let c1 = -10.0
        let c2 = 3.0
        delta = pow(10.0, zoom / c1 + c2)
        
    }
}
