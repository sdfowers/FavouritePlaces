//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 28/4/2023.
//

import SwiftUI
import CoreData

struct DetailView: View {
    //@Environment(\.managedObjectContext) var ctx
    var place:Place
    @State var name = ""
    @State var details = ""
    @State var imageURL = ""
    @State var lattitude = ""
    @State var longitude = ""
    @State var isEditing = false
    @State var image = defaultImage
    var body: some View {
        VStack {
            if !isEditing {
                List {
                    Text("\(name)").listRowBackground(Color.gray.opacity(0.05))
                    image.scaledToFit().cornerRadius(10).listRowBackground(Color.gray.opacity(0.05))
                    Text("\(details)").lineLimit(/*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/).listRowBackground(Color.gray.opacity(0.05))
                    Text("Lattitude: \(lattitude)").listRowBackground(Color.gray.opacity(0.05))
                    Text("Longitude: \(longitude)").listRowBackground(Color.gray.opacity(0.05))
                }
            } else {
                List {
                    HStack {
                        Label("Name:", systemImage: "map")
                        TextField("place name", text: $name)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    
                    HStack {
                        Label("Image URL:", systemImage: "photo")
                        TextField("enter an image url", text: $imageURL)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    
                    HStack {
                        Label("Details:", systemImage: "doc.plaintext")
                        TextField("Describe the place", text: $details)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    
                    HStack {
                        Label("Lattitude:", systemImage: "mappin")
                        TextField("0.0", text: $lattitude)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    
                    HStack {
                        Label("Longitude:", systemImage: "mappin")
                        TextField("0.0", text: $longitude)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                }
            }
        }
        .navigationTitle(name)
        .navigationBarItems(
            trailing: Button("\(isEditing ? "Confirm" : "Edit")") {
            if(isEditing) {
                place.strName = name
                place.strDetails = details
                place.strURL = imageURL
                place.strLongitude = longitude
                place.strLattitude = lattitude
                saveData()
                Task {
                    image = await place.getImage()
                }
            }
            isEditing.toggle()
            }
        )
        .onAppear {
            name = place.strName
            details = place.strDetails
            imageURL = place.strURL
            longitude = place.strLongitude
            lattitude = place.strLattitude
        }
        .onDisappear {
            saveData()
        }
        .task {
            await image = place.getImage()
        }
    }
}
