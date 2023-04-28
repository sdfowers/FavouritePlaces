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
    @State var lattitude = 0.0
    @State var longitude = 0.0
    @State var isEditing = false
    @State var image = defaultImage
    
    var body: some View {
        VStack {
            if !isEditing {
                List {
                    Text("Name: \(name)")
                    Text("Image URL: \(imageURL)").scaledToFit().frame(height: 30)
                    image.scaledToFit().cornerRadius(20).shadow(radius: 20)
                    Text("Details: \(details)")
                }
            } else {
                List {
                    HStack {
                        Text("Name: ")
                        TextField("Name: ", text: $name)
                        
                    }
                    HStack {
                        Text("ImageURL:")
                        TextField("Image URL: ", text: $imageURL)
                    }
                    
                    TextField("Details: ", text: $details)
                }
            }
            HStack {
                Button("\(isEditing ? "Confirm" : "Edit")") {
                    if(isEditing) {
                        place.strName = name
                        place.strDetails = details
                        place.strURL = imageURL
                        place.longitude = longitude
                        place.lattitude = lattitude
                        saveData()
                        Task {
                            image = await place.getImage()
                        }
                    }
                    isEditing.toggle()
                }
            }
        }
        .onAppear {
            name = place.strName
            details = place.strDetails
            imageURL = place.strURL
            longitude = place.longitude
            lattitude = place.lattitude
        }
        .task {
            await image = place.getImage()
        }
    }
}
