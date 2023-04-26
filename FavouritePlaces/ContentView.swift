//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 26/4/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var ctx                        //Get passed persistence handler (ph) into ctx
    @FetchRequest(entity: Place.entity(), sortDescriptors: [])
    var places:FetchedResults<Place>
    
    @State var name = ""
    
    var body: some View {
        NavigationView() {
            VStack {
                Text("Input Place Name")
                TextField("Place Name", text: $name)
                Button("Add new Place") {
                    addNewPlace()
                    name = ""
                }
                List {
                    ForEach(places) {
                        place in
                        Text(place.name ?? "")
                    }
                }
            }
            .padding()
            .navigationTitle("My Places")
        }
    }
    
    func addNewPlace() {
        if name == "" {return}
        let place = Place(context: ctx)
        place.name = name
        saveData()
    }
}
