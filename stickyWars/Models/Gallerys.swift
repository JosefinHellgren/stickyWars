//
//  Gallerys.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-07.
//

import Foundation
import UIKit
import ARKit
import FirebaseStorage


class Gallerys : ObservableObject, Identifiable{
    static let shared = Gallerys()
    @Published var selectedGallery : Gallery = Gallery(worldMap: "Sten", longitude: 37.3323341, latitude: -122.0312186, descriptionOfPlacement: "Somewhere wierd", userName: "Josefin")
    @Published var myGalleries : [Gallery] = []
    


func saveMapToFirebaseStorage(name : String ){
    
    ARViewContainer.ARVariables.arView.session.getCurrentWorldMap { (worldMap, _) in
        
        if let map: ARWorldMap = worldMap {
            
            let data = try! NSKeyedArchiver.archivedData(withRootObject: map,
                                                         requiringSecureCoding: true)
            
            let storageRef = Storage.storage().reference()
            let path = name
            let fileRef = storageRef.child(path)
            
            
            
            let uploadTask = fileRef.putData(data, metadata: nil) { metadata, error in
                if error == nil && metadata != nil{
                    
                
                }
                
                
                
            }
        }
    }




}
    
    
    
}

