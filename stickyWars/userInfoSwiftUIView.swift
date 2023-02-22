//
//  userInfoSwiftUIView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-20.
//

import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

struct userInfoSwiftUIView: View {
    
    var list :[String] = ["viewfinder","viewfinder","viewfinder","viewfinder","viewfinder","viewfinder","viewfinder", "viewfinder"]
   
    @ObservedObject var viewModel = ProfileViewModel()
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 40), count: 2)
    
    var body: some View {
        ZStack(alignment: .top){
        Image("gradient")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.top, -80)
            Spacer()

        VStack {
           
                 if let user = viewModel.user {
                     Text(user.name)
                         .foregroundColor(Color.white)
                         .font(.title)
                     Text(user.email)
                         .foregroundColor(Color.white)
                         .font(.title)
                     Text("Art collected:" + String(user.score))
                         .foregroundColor(Color.white)
                         .font(.title)
                    
             }
            Spacer()
            Spacer()
            Text("Art you collected:")
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: gridItemLayout, spacing: 15){
           
                
             
          
                    ForEach(0..<list.count,id: \.self){
                        index in
                        
                        Image(systemName: list[index])
                            .resizable()
                            .frame(width: 100, height: 100)
                            
                    }
                }
            }
            
            
            Spacer()
        }
             .onAppear {
                 viewModel.fetchUserData()
             }
         }
    }
    
}



