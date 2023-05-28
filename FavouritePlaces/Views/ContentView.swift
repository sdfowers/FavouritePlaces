//
//  ContentView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 26/4/2023.
//

import SwiftUI
import CoreData

///ContentView is the landing page of the FavouritePlaces app.
///A places array of the Place object and created and set by fetching the data from the Model database using coredata.
///The user can view the list of saved places, go into their details, and add / delete them.
struct ContentView: View {
    @Environment(\.managedObjectContext) var ctx                        //Get persistence handler into ctx
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var places:FetchedResults<Place>       //Fetched data is stored in the places array of the Place Object.
    @State var title = "My Favourite Places"
    var body: some View {
        NavigationView() {
            VStack {
                List {
                    //Loop through the places array to display each place.
                    ForEach(places) {
                        place in
                        //Navigate to DetailView, giving the relevant place object.
                        NavigationLink(destination: DetailView(place: place)) {
                                RowView(place: place)
                        }
                        .listRowBackground(Color.gray.opacity(0.05))
                    }.onDelete{ idx in
                        deletePlace(idx)        //Call delete function to delete object.
                    }
                }
            }
            .padding()
            .navigationTitle(title)
            .navigationBarItems(
                leading: Button(action: addNewPlace) {Label("", systemImage: "plus")},
                trailing: EditButton()
            )
            .onAppear {
                
            }
        }
    }
    
    //Add a new place to the places array.
    func addNewPlace() {
        let place = Place(context: ctx)
        place.name = "New Place"
        saveData()      //Save to coredata.
    }
    //Delete place from the place array and from coredata.
    func deletePlace(_ idx: IndexSet) {
        idx.map{places[$0]}.forEach { place in
            ctx.delete(place)
        }
        saveData()      //Save/update coredata.
    }
}
