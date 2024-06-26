//
//  RowView.swift
//  FavouritePlaces
//
//  Created by Sean Fowers on 28/4/2023.
//

import SwiftUI

///RowView displays the row seen in the contentview.
///This is for displaying the small image and place name.
struct RowView: View {
    @ObservedObject var place:Place
    @State var image = defaultImage
    
    var body: some View {
        HStack {
            image.frame(width: 40, height: 40).cornerRadius(5)
            Text(place.strName)
        }
        .task {
            image = await place.getImage()
        }
    }
}
