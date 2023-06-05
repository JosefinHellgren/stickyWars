//
//  Collection.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-01-24.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class Collection : ObservableObject {
    
 
    static let shared = Collection()
    
     @Published var myCollection : [Drawing] = []
 
    
    @Published var myPhotoAlbum : [Drawing] = []
    @Published var selectedDrawing : String = "https://firebasestorage.googleapis.com:443/v0/b/streetgallery-cd734.appspot.com/o/Bj%C3%B6rn0AC0B1F9-430D-490E-BB59-A071E25E3325.jpeg?alt=media&token=449857e1-5a42-41fe-b2fc-baccfc571569"
    @Published var selectedPhoto : String = ""
    
    

}




    



