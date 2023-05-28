//
//  Persistence.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 26/4/2023.
//

import Foundation
import CoreData

///Persistance Handler loads the coredata from the Model database.
struct PersistanceHandler {
    static let shared = PersistanceHandler()
    let container : NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores {_, error in
            if let e = error {
                fatalError("loading error with \(e)")
            }
        }
    }
}


