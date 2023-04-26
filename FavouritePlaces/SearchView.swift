//
//  SearchView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 27/4/2023.
//

import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) var ctx
    var name:String
    @State var results:[Place]?
    
    var body: some View {
        List{
            ForEach(results ?? []) {
                place in
                Text(place.name ?? "")
            }
        }.navigationTitle("Search Results")
            .task{
                let fetchRequest = Place.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name contains %@", name)
                results = try? ctx.fetch(fetchRequest)
            }
    }
}
