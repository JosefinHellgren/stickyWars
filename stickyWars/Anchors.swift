//
//  Anchors.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-09.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import Firebase

struct Anchors : Encodable, Decodable, Identifiable{
    
    @DocumentID var id: String?
  
    
    
    var identifier : UUID
    var image : String
    var points : Int = 2
    
}

