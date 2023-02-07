//
//  MyPhotoCollectionView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-06.
//

import SwiftUI

struct MyPhotoCollectionView: View {
    @ObservedObject var collection: Collection = .shared
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    var body: some View {
        
        VStack{
        ScrollView(.vertical, showsIndicators: false){
            LazyVGrid(columns: gridItemLayout, spacing: 0){
       
            ForEach(0..<collection.myPhotoAlbum.count,id: \.self){
                    index in
                    
                    Button(action: {
                        print("You pressed \(collection.myPhotoAlbum[index].name)")
                        
                        }){
                            let url = collection.myPhotoAlbum[index].url
                            
                            AsyncImage(url: URL(string: url))
                           { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 150, height: 150)
                            
                                
                                }
                                
                                .buttonStyle(PlainButtonStyle())
                                
                                .cornerRadius(20.0)
                                .border(Color.green.opacity(0.60), width: 0.0 )
                            
                        }
        }
                                                                    }
        }
              
        }
    }


struct MyPhotoCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        MyPhotoCollectionView()
    }
}
