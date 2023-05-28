//
//  MapView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 11/5/2023.
//

import SwiftUI
import MapKit
import CoreData

///Map View utilises the MapModel and all its functionality to display an interactive map to the user.
///The user can move the map, search for address, and search for given lat/long coordinates.
///Upon entering this view, the map will try to adjust to find and view the place name if no exact address has been given.
/// - Parameters
///     - places : Array of Place Object
///     - place : Place object
///     - map : Map Object
///     - mark : CLPlacemark
///     - zoom: Double
///     - address : String
///     - latitude : String
///     - longitude : String
///     - isEditing : Boolean
struct MapView: View {
    //@StateObject var manager = LocManager()
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var places:FetchedResults<Place>
    @ObservedObject var place: Place
    @ObservedObject var map: MapModel = .shared
    @State var mark:CLPlacemark?        //For display placemarks on the map for each place.
    @State var zoom = 30.0              //For adjusting the zoom level of the map.
    @State var address = ""
    @State var latitude = "0.0"
    @State var longitude = "0.0"
    @State var isEditing = false
    var body: some View {
        VStack (spacing: 0) {
            //Using a list for styling
            List {
                //Display the place name as a title.
                HStack {
                    Text(place.strName).font(.title)
                    Spacer()
                    //If isEditing is true, allow a small icon button to move to location of place name.
                    if isEditing {
                        Image(systemName: "paperplane.circle.fill").foregroundColor(.blue)
                            //OnTap using place name as the address, try to find and go to location.
                            .onTapGesture {
                                address = place.strName
                                checkAddress()
                            }
                    }
                }.listRowBackground(Color.gray.opacity(0.05))
                //Display the address
                HStack {
                    Text("Address: ")
                    //If isEditing, allow editing of address string and searching for the location.
                    if !isEditing {
                        Text(address)
                    } else {
                        TextField("Address", text: $address)
                        Image(systemName: "magnifyingglass").foregroundColor(.blue)
                            //Ontap go to address location.
                            .onTapGesture {
                                checkAddress()
                            }
                    }
                }.listRowBackground(Color.gray.opacity(0.05))
                //Display the latitude and longitude.
                HStack {
                    //If isEditing, allow editing and searching of lat/long
                    if !isEditing {
                        Text("Lat: \(latitude)")
                        Text("Long: \(longitude)")
                    } else {
                        Text("Lat:")
                        TextField("Latitude:", text: $latitude)
                        Text("Long:")
                        TextField("Longitude:", text: $longitude)
                        Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue)
                            //OnTap go to lat/long coordinates
                            .onTapGesture {
                                checkLocation()
                            }
                    }
                }.listRowBackground(Color.gray.opacity(0.05))
                //Slider to adjust zoom level of the map.
                Slider(value: $zoom, in: 10...60) {
                    if !$0 {
                        checkZoom()
                    }
                }.listRowBackground(Color.gray.opacity(0.05))
            }
            //ZStack to display the map with a small overlay.
            ZStack() {
                //Display the map and allow mapannotation of the previously saved places.
                //When clicking on an annotation, navigate to the detailview of that place.
                Map(coordinateRegion: $map.region, annotationItems: places) {
                    loc in
                    MapAnnotation(coordinate: loc.coord) {
                        NavigationLink(destination: DetailView(place: loc)) {
                            Image(systemName: "paperplane.circle.fill").foregroundColor(.red)
                            Text(loc.strName).fontWeight(.bold).foregroundColor(.red)
                        }
                        
                    }
                }
                //Small overlay to display maps current lat/long coordinates
                VStack(alignment: .leading) {
                    Text("Latitude:\(map.region.center.latitude)").font(.footnote)
                    Text("Longitude:\(map.region.center.longitude)").font(.footnote)
                    //Update button to move/save coords as the places location.
                    Button("Update") {
                        checkMap()
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                .padding(10)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .offset(x: 10, y: 180)
            }.padding(.top, -150.0)
            
        }
        .navigationBarItems(
            trailing: Button("\(isEditing ? "Confirm" : "Edit")") {
                //Enter/exit edit mode with isEditing
                //Update lat/long/address values upon confirmation and save to coredata.
                if(isEditing) {
                place.longitude = map.longitude
                place.latitude = map.latitude
                place.address = map.address
                saveData()
            }
            isEditing.toggle()
            }
        )
        //Update the map and zoom level upon function completion.
        .task {
            checkMap()
            checkZoom()
        }
        //When entering the map, transfer lat/long/address data and go to address if there is one.
        .onAppear {
            map.latitude = place.latitude
            map.longitude = place.longitude
            map.address = place.strAddress
            address = place.strAddress
            checkAddress()
        }
    }
    func checkAddress() {
        //fromAddressToLocation and fromAddressToLocationOld both function and can be used.
        //Old works with animation.
        map.address = address
        map.fromAddressToLocationOld(updateViewLocation)
    }
    func checkLocation() {
        //Using pages current lat/long, go to the coordinates.
        map.longStr = longitude
        map.latStr = latitude
        map.fromLocationToAddress()
        map.setupRegion()
    }
    func checkZoom() {
        //Adjust the zoom level of the map.
        checkMap()
        map.fromZoomToDelta(zoom)
        map.setupRegion()
    }
    func checkMap() {
        //Get maps current center coordinates and address
        map.updateFromRegion()
        address = map.address
        latitude = map.latStr
        longitude = map.longStr
        map.fromLocationToAddress()
    }
    func updateViewLocation() {
        //Set lat/long to maps current coordinates.
        latitude = map.latStr
        longitude = map.longStr
    }
    func locInfoCB(_ mk: CLPlacemark?) {
        //Get information from the location.
        mark = mk
    }
}
