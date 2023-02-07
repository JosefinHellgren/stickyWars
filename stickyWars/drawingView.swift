//
//  drawingView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-01-19.
//

import SwiftUI
import PencilKit
import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth


struct drawingView: View {
    @Binding var canvas : PKCanvasView
    @ObservedObject var collection: Collection = .shared
    @Binding var myCollection : [UIImage]
    
    
    var body: some View {
        
        VStack{
            
            
            Home(canvas: $canvas)
            
            
        }
        
    }
    
    
}


struct Home : View{
   
    @State var toolPicker = PKToolPicker()
    @Binding var canvas : PKCanvasView
    @ObservedObject var collection: Collection = .shared
    @State var showBigPic : Bool = false
    @State var selectedImage = String()
    @State private var presentAlert = false
    @State private var nameOfDrawing : String = ""
   
    
    var body: some View{
        ZStack{
            VStack{
           
                
            HStack{
                //button for choosing background canvas for the painting module
                     //button to clear the canvas and restart with white canvas
                    Button(action: {print("you want to choose background picture")
                        canvas.drawing = PKDrawing()
                    }){
                        Image(systemName: "washer")
                    }
                Button("Save Image") {presentAlert = true
                    
                    
                    print("pressed save")
                }
                
                .alert("Name", isPresented: $presentAlert, actions: {
                            TextField("name", text: $nameOfDrawing)
                        .foregroundColor(.pink)

                            
                            Button("Save", action: {
                                
                                
                                let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: 400, height: 700), scale: 1.0)

                                
                                saveToFirebaseStorage(image: image)
                               
                                })
                            Button("Cancel", role: .cancel, action: {})
                        }, message: {
                            Text("Please enter a name for your Drawing")
                        })
                .buttonStyle(.bordered)
                    .cornerRadius(10.0)
                    .foregroundColor(.white)
                    .background(.green)
                    .font(.system(size: 24))
                    .padding()
            }
              
                DrawingView(toolPicker: $toolPicker, canvas: $canvas)
                
               }
           
            
        }
        
    }
   
    func saveToFirebaseStorage(image : UIImage) {
    
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
                    let drawing = Drawing(url: urlString, name: nameOfDrawing)
                    try? db.collection("Users").document(user!.uid).collection("Images").addDocument(from : drawing)
                   
                }
            }
            
        }
        uploadTask.resume()

    }


    }
    
    struct BigPic : View{
        @Binding var image : String
        var body: some View{
            ZStack{
                
                AsyncImage(url: URL(string: image))
               { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                
                
                
            }
            
        }
        
    }

    
    struct DrawingView : UIViewRepresentable{
        @ObservedObject var collection: Collection = .shared
        // to capture drawing for saving
       @Binding var toolPicker : PKToolPicker
        @Binding var canvas : PKCanvasView
        
      
        func makeUIView(context: Context) -> PKCanvasView {
            canvas.drawingPolicy = .anyInput
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            
            //lägga till bakgrundsbild
            /*canvas.isOpaque = true
            let imageView = UIImageView(image: UIImage(named: "deer"))
            
            canvas.insertSubview(imageView, at: 100)*/
            
           /* let imageView = UIImageView(image: UIImage(named: "deer"))
                      let subView = self.canvas.subviews[0]
                          subView.addSubview(imageView)
                          subView.sendSubviewToBack(imageView)*/
            
            
            canvas.becomeFirstResponder()
            
            
            return canvas
        }
        func updateUIView(_ uiView: PKCanvasView, context: Context) {
            //
        }
        
        
        
        
        
    }
    
    

