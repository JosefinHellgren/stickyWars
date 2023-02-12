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
    
    //demo content images
     @Published var myCollection : [Drawing] = []
    
    
    @Published var myPhotoAlbum : [Drawing] = []
    @Published var selectedDrawing : String = "https://firebasestorage.googleapis.com/v0/b/streetgallery-cd734.appspot.com/o/images1E7FFC1C-FF5A-4D66-BC3F-2E0BD06CCD3B.jpeg?alt=media&token=0861bebb-c9e5-4cec-bdad-2f73d6fc753b"
    @Published var selectedPhoto : String = ""
    
    

}
func createDemoData(){
    //add images and photos to the collections
    
   
}
func listenToFirestore(collection : Collection) {
   // guard let uid = Auth.auth().currentUser?.uid else {return}
    let db = Firestore.firestore()
        db.collection("Images").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                collection.myCollection.removeAll()
                for document in snapshot.documents {

                    let result = Result {
                        try document.data(as: Drawing.self)
                    }
                    switch result  {
                    case .success(let drawing)  :
                        collection.myCollection.append(drawing)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }



    



