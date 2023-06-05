//
//  MyCollectionView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-01.
//

import SwiftUI
// here we have a grid page with all your creations and also a upload button for own pictures and in that function also enable camera function.
struct MyCollectionView: View {
    @ObservedObject var collection: ArtworkCollection = .shared
    @State var showPicker = false
    @State var selectedImage : UIImage?
    @State var mySelectedImage = String()
    @State var showBigPic : Bool = false
    
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 40), count: 2)
    var body: some View {
        ZStack{
           
             
        VStack{
            
            Button(action: {print("upload picture")
                showPicker = true
                
            }){
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .foregroundColor(Color.white)
                    
                   
                    .frame(width: 70, height: 70, alignment: .center)
                
            }
            .sheet(isPresented: $showPicker){
               
                ImagePicker(selectedImage: $selectedImage, showPicker : $showPicker)
            }
            Text("DRAWINGS")
                .foregroundColor(Color.white)
                .font(.largeTitle)
        
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: gridItemLayout, spacing: 15){
           
                
             
          
                    ForEach(0..<collection.myDrawings.count,id: \.self){
                        index in
                        
                        Button(action: {
                            print("You pressed \(collection.myDrawings[index].name)")
                            
                            collection.selectedDrawing = collection.myDrawings[index].url
                            print(collection.selectedDrawing)
                            showBigPic = true
                            mySelectedImage = collection.myDrawings[index].url
                            
                               
                            
                        }){
                            let url = collection.myDrawings[index].url
                            
                            AsyncImage(url: URL(string: url))
                           { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 200, height: 200)
                            
                                
                                }.sheet(isPresented: $showBigPic) {
                                    BigPic(image: $mySelectedImage)
                                }
                                
                                .buttonStyle(PlainButtonStyle())
                                
                                .cornerRadius(20.0)
                                .border(Color.green.opacity(0.60), width: collection.selectedDrawing == collection.myDrawings[index].url ? 5.0 : 0.0 )
                                
                            
                        }
        }
                                                                    }
                        
              
        }
    }
        .background(LinearGradient(colors: [Color.purple.opacity(0.5), Color.yellow.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .background(LinearGradient(colors: [Color.pink.opacity(0.5), Color.yellow.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .background(LinearGradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
        
        .edgesIgnoringSafeArea(.all)
    
}
}


struct imagePicker : View{
    @State var isPickerShowing = false
    @State var selectedImage : UIImage?
    
    var body: some View{
        ZStack{
            
            if selectedImage != nil{
                Image(uiImage: selectedImage!)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
            }
            Button{
                isPickerShowing = true
                
            } label:{ Text("Select a photo")
                
                
            }
            
            
            
            
            
        }
        
        
        
        
    }
}
