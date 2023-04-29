//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 26/4/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var ctx                        //Get persistence handler into ctx
    @FetchRequest(entity: Place.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var places:FetchedResults<Place>
    @State var name = ""
    @State var title = "My Favourite Places"
    var body: some View {
        NavigationView() {
            VStack {
                List {
                    ForEach(places) {
                        place in
                        NavigationLink(destination: DetailView(place: place)) {
                                RowView(place: place)
                        }
                        .listRowBackground(Color.gray.opacity(0.05))
                    }.onDelete{ idx in
                        deletePlace(idx)
                    }
                }
            }
            .padding()
            .navigationTitle(title)
            .navigationBarItems(
                leading: Button(action: addNewPlace) {Label("", systemImage: "plus")},
                trailing: EditButton()
            )
        }
    }
    func addNewPlace() {
        let place = Place(context: ctx)
        place.name = "New Place"
        saveData()
    }
    func deletePlace(_ idx: IndexSet) {
        idx.map{places[$0]}.forEach { place in
            ctx.delete(place)
        }
        saveData()
    }
    /*
    func addPlaceplus.square() {
        if name == "" {return}
        let place = Place(context: ctx)
        place.name = name
        saveData()
    }*/
}
