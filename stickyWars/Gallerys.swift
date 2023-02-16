//
//  Gallerys.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-07.
//

import Foundation
import UIKit
class Gallerys : ObservableObject, Identifiable{
    static let shared = Gallerys()
    @Published var selectedGallery : Gallery = Gallery(worldMap: "Sten", longitude: 37.3323341, latitude: -122.0312186, descriptionOfPlacement: "Somewhere wierd", userName: "Josefin")
    @Published var myGalleries : [Gallery] = []
    
}
