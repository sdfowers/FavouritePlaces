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

extension Place {
    var strName:String {
        get {
            self.name ?? "New Place"
        }
        set {
            self.name = newValue
        }
    }
    var strDetails:String {
        get {
            self.details ?? ""
        }
        set {
            self.details = newValue
        }
    }
    var strAddress:String {
        get {
            self.address ?? ""
        }
        set {
            self.address = newValue
        }
    }
    var strLatitude:String {
        get {
            "\(self.latitude)"
        }
        set {
            guard let latitude = Double(newValue) else {return}
            self.latitude = latitude
        }
    }
    var strLongitude:String {
        get {
            "\(self.longitude)"
        }
        set {
            guard let longitude = Double(newValue) else {return}
            self.longitude = longitude
        }
    }
    var strURL:String {
        get {
            self.imageURL?.absoluteString ?? ""
        }
        set {
            guard let url = URL(string: newValue) else {return}
            self.imageURL = url
        }
    }
    
    var coord: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
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

func saveData() {
    let ctx = PersistanceHandler.shared.container.viewContext
    do {
        try ctx.save()
    } catch {
        fatalError("Save error with \(error)")
    }
}
