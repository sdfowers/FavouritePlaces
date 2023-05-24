//
//  MapView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 11/5/2023.
//

import SwiftUI
import MapKit
import CoreData

struct MapView: View {
    //@StateObject var manager = LocManager()
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var places:FetchedResults<Place>
    @ObservedObject var place: Place
    @ObservedObject var map: MapModel = .shared
    @State var zoom = 10.0
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
                }.offset(x: 10, y: 250)
            }
        }
        //.navigationTitle(place.strName)
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
        map.address = address
        map.fromAddressToLocationOld(updateViewLocation)
        /*
        Task {
            await map.fromAddressToLocation()
            latitude = map.latStr
            longitude = map.longStr
        }
        */
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
}
