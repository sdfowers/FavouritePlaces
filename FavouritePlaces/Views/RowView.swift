//
//  RowView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 28/4/2023.
//

import SwiftUI

struct RowView: View {
    var place:Place
    @State var image = defaultImage
    
    var body: some View {
        HStack {
            image.frame(width: 40, height: 40).clipShape(Circle())
            Text(place.strName)
        }
        .task {
            image = await place.getImage()
        }
    }
}
