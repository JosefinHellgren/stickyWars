//
//  MyPhotoCollectionView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-06.
//

import SwiftUI

struct MyPhotoCollectionView: View {
    @ObservedObject var collection: Collection = .shared
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 30), count: 2)
    
    @State var mySelectedPhoto = String()
    @State var showBigPic : Bool = false
    var body: some View {
        ZStack{
            
            
            
        VStack{
           
               
        ScrollView(.vertical, showsIndicators: false){
            LazyVGrid(columns: gridItemLayout, spacing: 4){
       
            ForEach(0..<collection.myPhotoAlbum.count,id: \.self){
                    index in
                    
                    Button(action: {
                     
                        
                        collection.selectedPhoto = collection.myPhotoAlbum[index].url
                        showBigPic = true
                        mySelectedPhoto = collection.myPhotoAlbum[index].url
                        
                           
                        
                    }){
                        let url = collection.myPhotoAlbum[index].url
                        
                        AsyncImage(url: URL(string: url))
                       { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 200, height: 200)
                        
                            
                            }.sheet(isPresented: $showBigPic) {
                                BigPic(image: $mySelectedPhoto)
                            }
                            
                            .buttonStyle(PlainButtonStyle())
                            
                            .cornerRadius(20.0)
                            .border(Color.green.opacity(0.60), width: collection.selectedPhoto == collection.myPhotoAlbum[index].url ? 5.0 : 0.0 )
                            
                          
                                
                    
                            
            }.padding(15)
            }
                                                                    }
        }
    }
        .background(LinearGradient(colors: [Color.blue.opacity(0.3), Color.green.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .background(LinearGradient(colors: [Color.yellow.opacity(0.4), Color.blue.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .background(LinearGradient(colors: [Color.white.opacity(0.4), Color.yellow.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing))
        
        .edgesIgnoringSafeArea(.all)
              
        }
    }


struct MyPhotoCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MyPhotoCollectionView()
    }
}
