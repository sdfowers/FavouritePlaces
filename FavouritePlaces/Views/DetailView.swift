//
//  DetailView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 28/4/2023.
//

import SwiftUI
import CoreData

///DetailView is navigated to from the ContentView page or the MapView page.
///A place object is given and displayed to the screen. Users can enter edit mode to adjust object attributes and save to coredata.
/// - Parameters
///     - place : Place
///     - name : String
///     - details : String
///     - address : String
///     - imageURL : String
///     - latitude : String
///     - longitude : String
///     - isEditing : Boolean
///     - image : Image
struct DetailView: View {
    //@Environment(\.managedObjectContext) var ctx
    @ObservedObject var place:Place
    //Temporary string variables for user editing purposes.
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
            //If not editing, display the place attributes to the screen.
            if !isEditing {
                List {
                    if image != defaultImage {      //If image is the default, show a small display.
                        image.scaledToFit().cornerRadius(10).listRowBackground(Color.gray.opacity(0.05))
                    } else {        //If actual image has been given, enlarge and fit to screen.
                        image.frame(width: 40, height: 40).cornerRadius(5).listRowBackground(Color.gray.opacity(0.05))
                    }
                    //Navigate to MapView for interactive map.
                    NavigationLink(destination: MapView(place: place)) {
                        Image(systemName: "map.fill").foregroundColor(.blue)
                        Text("Map of \(name)")
                    }.listRowBackground(Color.gray.opacity(0.05))
                    //Display address only if it isn't the same as or name or an empty string.
                    if address != name && address != "" {
                        HStack {
                            Image(systemName: "house.fill").foregroundColor(.blue)
                            Text("\(address)")
                        }.listRowBackground(Color.gray.opacity(0.05))
                    }
                    //If details exist, display to screen, else do not show.
                    if details != "" {
                        HStack {
                            Image(systemName: "info.circle.fill").foregroundColor(.blue)
                            Text("\(details)").lineLimit(/*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
                        }.listRowBackground(Color.gray.opacity(0.05))
                    }
                    //Latitude display.
                    HStack {
                        Image(systemName: "globe.europe.africa.fill").foregroundColor(.blue)
                        Text("Lattitude: \(latitude)")
                    }.listRowBackground(Color.gray.opacity(0.05))
                    //Longitude display.
                    HStack {
                        Image(systemName: "globe.asia.australia.fill").foregroundColor(.blue)
                        Text("Longitude: \(longitude)")
                    }.listRowBackground(Color.gray.opacity(0.05))
                    //Using the place display methods, the timezone, sunrise and sunsets are displayed to screen.
                    place.timeZoneDisplay.listRowBackground(Color.gray.opacity(0.05))
                    place.sunriseDisplay.listRowBackground(Color.gray.opacity(0.05))
                    place.sunsetDisplay.listRowBackground(Color.gray.opacity(0.05))
                }
            //If isEditing is true, change display to textfields for adjusting each attribute.
            } else {
                List {
                    //Display and edit name var.
                    HStack {
                        Label("Name:", systemImage: "map")
                        TextField("place name", text: $name)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    //Display and edit imageURL var.
                    HStack {
                        Label("Image URL:", systemImage: "photo")
                        TextField("enter an image url", text: $imageURL)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    //Display and edit address var.
                    HStack {
                        Label("Address:", systemImage: "doc.plaintext")
                        TextField("1 place street", text: $address)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    //Display and edit details var.
                    HStack {
                        Label("Details:", systemImage: "doc.plaintext")
                        TextField("Describe the place", text: $details)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    //Display and edit latitude var.
                    HStack {
                        Label("Latitude:", systemImage: "mappin")
                        TextField("0.0", text: $latitude)
                            .foregroundColor(Color.black.opacity(0.75))
                    }.listRowBackground(Color.gray.opacity(0.05))
                    //Display and edit longitude var.
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
            if(isEditing) {     //Upon confirming the edit, all details are saved to place through the str conversion attributes and saved to coredata.
                place.strName = name
                place.strDetails = details
                place.strAddress = address
                place.strURL = imageURL
                place.strLongitude = longitude
                place.strLatitude = latitude
                saveData()
                Task {  //Async function for image fetching and displaying.
                    image = await place.getImage()
                }
            }
            isEditing.toggle()  //Toggle the isEditing boolean to determine if editing has been enabled.
            }
        )
        //Set all ContentView vars to the given place objects attributes.
        .onAppear {
            name = place.strName
            details = place.strDetails
            address = place.strAddress
            imageURL = place.strURL
            longitude = place.strLongitude
            latitude = place.strLatitude
        }
        //Fetch timezone and image data through async methods.
        .task {
            place.fetchTimeZone()
            await image = place.getImage()
        }
    }
}
