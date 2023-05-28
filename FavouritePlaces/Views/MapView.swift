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
        VStack (alignment: .leading) {
            HStack {
                Text(place.strName).font(.title)
                Spacer()
                if isEditing {
                    Image(systemName: "paperplane.circle.fill").foregroundColor(.blue)
                        .onTapGesture {
                            address = place.strName
                            checkAddress()
                        }
                }
            }
            HStack {
                Text("Address")
                if !isEditing {
                    Text(address)
                } else {
                    TextField("Address", text: $address)
                    Image(systemName: "magnifyingglass").foregroundColor(.blue)
                        .onTapGesture {
                            checkAddress()
                        }
                }
            }
            HStack {
                if !isEditing {
                    Text("Lat: \(latitude)")
                    Text("Long: \(longitude)")
                } else {
                    Text("Lat:")
                    TextField("Latitude:", text: $latitude)
                    Text("Long:")
                    TextField("Longitude:", text: $longitude)
                    Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue)
                        .onTapGesture {
                            checkLocation()
                        }
                }
            }
            Slider(value: $zoom, in: 10...60) {
                if !$0 {
                    checkZoom()
                }
            }
            ZStack {
                Map(coordinateRegion: $map.region, annotationItems: places) {
                    loc in
                    MapAnnotation(coordinate: loc.coord) {
                        NavigationLink(destination: DetailView(place: loc)) {
                            Image(systemName: "paperplane.circle.fill").foregroundColor(.red)
                            Text(loc.strName).fontWeight(.bold).foregroundColor(.red)
                        }
                        
                    }
                }
                VStack(alignment: .leading) {
                    Text("Latitude:\(map.region.center.latitude)").font(.footnote)
                    Text("Longitude:\(map.region.center.longitude)").font(.footnote)
                    Button("Update") {
                        checkMap()
                    }
                }.offset(x: 10, y: 180)
            }
            
        }
        .navigationBarItems(
            trailing: Button("\(isEditing ? "Confirm" : "Edit")") {
            if(isEditing) {
                place.longitude = map.longitude
                place.latitude = map.latitude
                place.address = map.address
                saveData()
            }
            isEditing.toggle()
            }
        )
        .task {
            checkMap()
            checkZoom()
            //place.checkLocation(locInfoCB)
        }
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
        map.longStr = longitude
        map.latStr = latitude
        map.fromLocationToAddress()
        map.setupRegion()
    }
    func checkZoom() {
        checkMap()
        map.fromZoomToDelta(zoom)
        map.setupRegion()
    }
    func checkMap() {
        map.updateFromRegion()
        address = map.address
        latitude = map.latStr
        longitude = map.longStr
        map.fromLocationToAddress()
    }
    func updateViewLocation() {
        latitude = map.latStr
        longitude = map.longStr
    }
    func locInfoCB(_ mk: CLPlacemark?) {
        mark = mk
    }
}
