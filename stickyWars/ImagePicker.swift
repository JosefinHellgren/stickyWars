//
//  ImagePicker.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-01.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
 
struct ImagePicker : UIViewControllerRepresentable {
    @Binding var selectedImage : UIImage?
    @Binding var showPicker : Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(self)
    }
    
    
    
}

class ImagePickerCoordinator : NSObject , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var parent: ImagePicker
    
    init(_ picker : ImagePicker){
        self.parent = picker
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //run this code when user has selected image
        print("Image selected")
       // guard let uid = Auth.auth().currentUser?.uid else {return}
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            guard image != nil else {return
            }
            
            let storageRef = Storage.storage().reference()
            let imageData = image.jpegData(compressionQuality: 0.8)
            guard imageData != nil else{return}
            
        
            
            let path = "\(UUID().uuidString).jpeg"
            
            
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
                        let drawing = Drawing(url: urlString, name: "picture", id: user!.uid)
                        try? db.collection("Users").document("images").collection("Images").addDocument(from : drawing)
                       
                    }
                }
                
            }
            uploadTask.resume()
            
        }
        
        parent.showPicker = false
        
        
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        @Binding var showPicker : Bool
        //run code when the user cancels the picker
        print("cancelled")
        parent.showPicker = false
    }
}
