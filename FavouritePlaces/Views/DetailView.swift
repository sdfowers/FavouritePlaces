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
                    Text("\(name)").multilineTextAlignment(.center).padding(.horizontal, 120.0).frame(alignment: .center)
                    image.scaledToFit().cornerRadius(10)
                    Text("\(details)")
                        .lineLimit(/*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
                    Text("Lattitude: \(lattitude)")
                    Text("Longitude: \(longitude)")
                }
            } else {
                List {
                    HStack {
                        Text("Name: ")
                        TextField("place name", text: $name)
                    }
                    
                    HStack {
                        Text("ImageURL: ")
                        TextField("enter an image url", text: $imageURL)
                    }
                    HStack {
                        Text("Details: ")
                        TextField("Describe the place", text: $details)
                    }
                    HStack {
                        Text("Lattitude: ")
                        TextField("0.0", text: $lattitude)
                    }
                    HStack {
                        Text("Longitude: ")
                        TextField("0.0", text: $longitude)
                    }
                    
                }
            }
        }
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
        .task {
            await image = place.getImage()
        }
    }
}
