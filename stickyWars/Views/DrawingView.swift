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


struct DrawingView: View {
    @State var toolPicker = PKToolPicker()
    
    @ObservedObject var collection: ArtworkCollection = .shared
    @State var showBigPic : Bool = false
    @State var selectedImage = String()
    @State private var presentAlert = false
    @State private var nameOfDrawing : String = ""
    @Binding var canvas : PKCanvasView
    
    var body: some View {
        ZStack{
            VStack{
                
                HStack{
                    Button(action: {print("clean canvas")
                        canvas.drawing = PKDrawing()
                    }){
                        Image(systemName: "washer")
                    }
                    alertView(presentAlert: $presentAlert, nameOfDrawing: $nameOfDrawing, canvas: $canvas)
                }
                
                PKCanvasViewWrapper(toolPicker: $toolPicker, canvas: $canvas)
            }
        }
    }

}



struct alertView : View{
    @Binding var presentAlert : Bool
    @Binding var nameOfDrawing : String
    @Binding var canvas : PKCanvasView
    @ObservedObject var collection: ArtworkCollection = .shared
    
    var body: some View{
        Button("Save Image") {
            presentAlert = true
        }
        .alert("Name", isPresented: $presentAlert, actions: {
            TextField("name", text: $nameOfDrawing)
                .foregroundColor(.pink)
            
            Button("Save", action: {
                let image = canvas.drawing.image(from: CGRect(x: 0, y: 0, width: 400, height: 700), scale: 1.0)
                collection.saveImageToFirebaseStorage(nameOfDrawing: nameOfDrawing, image: image)
                
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
}

struct PKCanvasViewWrapper : UIViewRepresentable{
    @Binding var toolPicker : PKToolPicker
    @Binding var canvas : PKCanvasView
    
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        
        return canvas
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        //
    }
}



