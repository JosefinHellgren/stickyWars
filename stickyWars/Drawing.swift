//
//  Drawings.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-01-26.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class Drawing : Encodable, Decodable, ObservableObject {
    
  
      
  
    
    let url : String
    let name : String
    let id : String
    
    init(url : String, name : String, id : String){
        self.url = url
        self.name = name
        self.id = id
    }
}

func saveToFirebaseStorage(nameOfDrawing : String,image : UIImage){
    
    guard image != nil else {return
    }
    
    let storageRef = Storage.storage().reference()
    let imageData = image.jpegData(compressionQuality: 0.8)
    guard imageData != nil else{return}
    

    
    let path = "\(nameOfDrawing)\(UUID().uuidString).jpeg"
    
    
    let fileRef = storageRef.child(path)
    
    let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
        
        if error == nil && metadata != nil{
            
          
        }
        fileRef.downloadURL {
            url, error in

            if let url = url {
              
                let db = Firestore.firestore()
                let user = Auth.auth().currentUser
                let urlString = url.absoluteString
                let drawing = Drawing(url: urlString, name: nameOfDrawing, id: user!.uid)
                try? db.collection("Users").document("images").collection("Images").addDocument(from : drawing)
               
            }
        }
        
    }
    uploadTask.resume()
    
    
    
}


