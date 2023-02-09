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
    
}
func fetchData(){
    let db = Firestore.firestore()
    
  db.collection("Anchors").addSnapshotListener { (querySnapshot, error) in
    guard let documents = querySnapshot?.documents else {
      print("No documents")
      return
    }
      
      let anchor = documents as? Anchors
      
      anchor?.image
  }
}
