//
//  Persistence.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 26/4/2023.
//

import Foundation
import CoreData

struct PH {
    static let shared = PH()
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

func saveData() {
    let ctx = PH.shared.container.viewContext
    do {
        try ctx.save()
    } catch {
        fatalError("Save error with \(error)")
    }
}
