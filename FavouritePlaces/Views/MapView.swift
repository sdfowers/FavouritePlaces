//
//  MapView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 11/5/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var place: Place
    @ObservedObject var map: MapModel = .shared
    @State var zoom = 10.0
    @State var latitude = "0.0"
    @State var longitude = "0.0"
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Address")
                TextField("Address", text: $map.name)
                Image(systemName: "magnifyingglass").foregroundColor(.blue)
                    .onTapGesture {
                        checkAddress()
                    }
            }
            HStack {
                Text("Lat/Long")
                TextField("Lat:", text: $latitude)
                TextField("Long:", text: $longitude)
                Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue)
                    .onTapGesture {
                        checkLocation()
                    }
            }
            Slider(value: $zoom, in: 10...60) {
                if !$0 {
                    checkZoom()
                }
            }
            ZStack {
                Map(coordinateRegion: $map.region)
                VStack(alignment: .leading) {
                    Text("Latitude:\(map.region.center.latitude)").font(.footnote)
                    Text("Longitude:\(map.region.center.longitude)").font(.footnote)
                    Button("Update") {
                        checkMap()
                    }
                }.offset(x: 10, y: 250)
            }
        }
        .task {
            checkMap()
        }
        .onAppear {
            map.latitude = place.lattitude
            map.longitude = place.longitude
        }
    }
    func checkAddress() {
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
        latitude = map.latStr
        longitude = map.longStr
        map.fromLocationToAddress()
    }
    func updateViewLocation() {
        latitude = map.latStr
        longitude = map.longStr
    }
}
