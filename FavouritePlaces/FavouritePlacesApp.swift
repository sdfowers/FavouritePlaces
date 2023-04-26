//
//  FavouritePlacesApp.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 26/4/2023.
//

import SwiftUI

@main
struct FavouritePlacesApp: App {
    var ph = PH.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, ph.container.viewContext)
        }
    }
}
