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
                TextField("Address", text: $place.strName)
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
            Map(coordinateRegion: $map.region)
        }
        .onAppear {
            map.lattitude = place.lattitude
            map.longitude = place.longitude
        }
    }
    func checkAddress() {
        
    }
    func checkLocation() {
        
    }
    func checkZoom() {
        
    }
}
