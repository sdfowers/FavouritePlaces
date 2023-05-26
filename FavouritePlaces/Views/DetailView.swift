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
    @ObservedObject var place:Place
    @State var name = ""
    @State var details = ""
    @State var address = ""
    @State var imageURL = ""
    @State var latitude = ""
    @State var longitude = ""
    @State var isEditing = false
    @State var image = defaultImage
    var body: some View {
        VStack {
            if !isEditing {
                List {
                    if image != defaultImage {
                        image.scaledToFit().cornerRadius(10).listRowBackground(Color.gray.opacity(0.05))
                    } else {
                        image.frame(width: 40, height: 40).cornerRadius(5).listRowBackground(Color.gray.opacity(0.05))
                    }
                    NavigationLink(destination: MapView(place: place)) {
                        Image(systemName: "map.fill").foregroundColor(.blue)
                        Text("Map of \(name)")
                    }.listRowBackground(Color.gray.opacity(0.05))
                    if address != name {
                        HStack {
                            Image(systemName: "house.fill").foregroundColor(.blue)
                            Text("\(address)")
                        }.listRowBackground(Color.gray.opacity(0.05))
                    }
                    if details != "" {
                        HStack {
                            Image(systemName: "info.circle.fill").foregroundColor(.blue)
                            Text("\(details)").lineLimit(/*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
                        }.listRowBackground(Color.gray.opacity(0.05))
                    }
                    HStack {
                        Image(systemName: "globe.europe.africa.fill").foregroundColor(.blue)
                        Text("Lattitude: \(latitude)").listRowBackground(Color.gray.opacity(0.05))
                    }
                    HStack {
                        Image(systemName: "globe.asia.australia.fill").foregroundColor(.blue)
                        Text("Longitude: \(longitude)").listRowBackground(Color.gray.opacity(0.05))
                    }
                    place.timeZoneDisplay.listRowBackground(Color.gray.opacity(0.05))
                    place.sunriseDisplay.listRowBackground(Color.gray.opacity(0.05))
                    place.sunsetDisplay.listRowBackground(Color.gray.opacity(0.05))
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
                        Label("Address:", systemImage: "doc.plaintext")
                        TextField("1 place street", text: $address)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    
                    HStack {
                        Label("Details:", systemImage: "doc.plaintext")
                        TextField("Describe the place", text: $details)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    
                    HStack {
                        Label("Lattitude:", systemImage: "mappin")
                        TextField("0.0", text: $latitude)
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
                place.strAddress = address
                place.strURL = imageURL
                place.strLongitude = longitude
                place.strLatitude = latitude
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
            address = place.strAddress
            imageURL = place.strURL
            longitude = place.strLongitude
            latitude = place.strLatitude
        }
        /*
        .onDisappear {
            saveData()
        } */
        .task {
            place.fetchTimeZone()
            await image = place.getImage()
        }
    }
}
