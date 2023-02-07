//
//  MyCollectionView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-01.
//

import SwiftUI
// here we have a grid page with all your creations and also a upload button for own pictures and in that function also enable camera function.
struct MyCollectionView: View {
    @ObservedObject var collection: Collection = .shared
    @State var showPicker = false
    @State var selectedImage : UIImage?
    @State var mySelectedImage = String()
    @State var showBigPic : Bool = false
    
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    var body: some View {
        VStack{
            
            Button(action: {print("upload picture or take picture")
                //show the imagePicker
                showPicker = true
                
            }){
                Image(systemName: "plus.app")
                    .resizable()
                    .foregroundColor(.green)
                   
                    .frame(width: 80, height: 80, alignment: .center)
                
            }
            .sheet(isPresented: $showPicker){
                //imagePicket
                ImagePicker(selectedImage: $selectedImage, showPicker : $showPicker)
            }
            
        
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: gridItemLayout, spacing: 0){
           
                
             
          
                    ForEach(0..<collection.myCollection.count,id: \.self){
                        index in
                        
                        Button(action: {
                            print("You pressed \(collection.myCollection[index].name)")
                            
                            collection.selectedDrawing = collection.myCollection[index].url
                            showBigPic = true
                            mySelectedImage = collection.myCollection[index].url
                            
                               
                            
                        }){
                            let url = collection.myCollection[index].url
                            
                            AsyncImage(url: URL(string: url))
                           { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            
                                
                                }.sheet(isPresented: $showBigPic) {
                                    BigPic(image: $mySelectedImage)
                                }
                                
                                .buttonStyle(PlainButtonStyle())
                                
                                .cornerRadius(20.0)
                                .border(Color.green.opacity(0.60), width: collection.selectedDrawing == collection.myCollection[index].url ? 5.0 : 0.0 )
                            
                        }
        }
                                                                    }
                        
              
        }
    }
    
}

/*struct MyCollectionView_Previews: PreviewProvider {
  
    static var previews: some View {
        MyCollectionView()
    }
}*/

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
