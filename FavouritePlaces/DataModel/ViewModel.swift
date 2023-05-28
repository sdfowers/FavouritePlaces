//
//  ViewModel.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 28/4/2023.
//

import Foundation
import CoreData
import MapKit
import SwiftUI

let defaultImage = Image(systemName: "photo").resizable()
var downloadImages:[URL:Image] = [:]

/// The Place object contains the data from our Model database. It pulls from the persistence handler and saves through it.
/// Through this object, the attributes are fetched and coordinates/placemarkers for the map object are held.
/// Place extends to add timezone fetching methods in the TimeZoneModel.
/// - Parameters
///     - name : String
///     - details : String
///     - address : String
///     - imageURL : URI
///     - latitude : Double
///     - longitude : Double
///     - timeZone : String
///     - sunsetTime : String
///     - sunriseTime : String
extension Place {
    //Get and set name as a String
    var strName:String {
        get {
            self.name ?? "New Place"
        }
        set {
            self.name = newValue
        }
    }
    //Get and set details as a string
    var strDetails:String {
        get {
            self.details ?? ""
        }
        set {
            self.details = newValue
        }
    }
    //Get and set address as a string
    var strAddress:String {
        get {
            self.address ?? ""
        }
        set {
            self.address = newValue
        }
    }
    //Get and set latitude as a string
    var strLatitude:String {
        get {
            "\(self.latitude)"
        }
        set {
            guard let latitude = Double(newValue) else {return}
            self.latitude = latitude
        }
    }
    //Get and set longitude as a string
    var strLongitude:String {
        get {
            "\(self.longitude)"
        }
        set {
            guard let longitude = Double(newValue) else {return}
            self.longitude = longitude
        }
    }
    //Get and set imageURL as a string
    var strURL:String {
        get {
            self.imageURL?.absoluteString ?? ""
        }
        set {
            guard let url = URL(string: newValue) else {return}
            self.imageURL = url
        }
    }
    
    //Get coordinates of place for mapmarkers.
    var coord: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    //Get location details for the current lat/long location.
    //Utilises a callback function with given location details.
    func checkLocation(_ cb: @escaping (CLPlacemark?)->Void) {
        let coder = CLGeocoder()
        coder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) {
            marks, error in
            if let err = error {
                print("error in checkLocation \(err)")
                return
            }
            let mark = marks?.first
            cb(mark)
        }
    }
    
    //Find and load image from online from given imageURL
    //Returns default image if no given image or imageURL could not be found.
    //Print error if unable to load image.
    func getImage() async ->Image {
        guard let url = self.imageURL else {return defaultImage}
        if let image = downloadImages[url] {return image}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let uiimg = UIImage(data: data) else {return defaultImage}
            let image = Image(uiImage: uiimg).resizable()
            downloadImages[url]=image
            return image
        } catch {
            print("Error downloading Image \(error)")
        }
        
        return defaultImage
    }
    
}

/// Saves Place data to Model Database through coredata.
func saveData() {
    let ctx = PersistanceHandler.shared.container.viewContext
    do {
        try ctx.save()
    } catch {
        fatalError("Save error with \(error)")
    }
}
