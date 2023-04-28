//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 26/4/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var ctx                        //Get passed persistence handler (ph) into ctx
    @FetchRequest(entity: Place.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var places:FetchedResults<Place>
    
    @State var name = ""
    
    var body: some View {
        NavigationView() {
            VStack {
                Text("Input Place Name")
                TextField("Place Name", text: $name).border(.blue)
                HStack {
                    Button("Add new Place") {
                        addNewPlace()
                        name = ""
                    }
                    Spacer()
                    NavigationLink("Search") {
                        SearchView(name: name)
                    }
                }
                List {
                    ForEach(places) {
                        place in
                        NavigationLink(destination: DetailView(place: place)) {
                            RowView(place: place)
                        }
                    }.onDelete{ idx in
                        deletePlace(idx)
                    }
                }
            }
            .padding()
            .navigationTitle("My Favourite Places")
        }
    }
    
    func addNewPlace() {
        if name == "" {return}
        let place = Place(context: ctx)
        place.name = name
        saveData()
    }
    
    func deletePlace(_ idx: IndexSet) {
        idx.map{places[$0]}.forEach { place in
            ctx.delete(place)
        }
        saveData()
    }
}
