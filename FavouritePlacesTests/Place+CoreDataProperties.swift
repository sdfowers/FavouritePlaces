//
//  Place+CoreDataProperties.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 28/5/2023.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var address: String?
    @NSManaged public var details: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var sunriseTime: String?
    @NSManaged public var sunsetTime: String?
    @NSManaged public var timeZone: String?

}

extension Place : Identifiable {

}
