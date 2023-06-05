//
//  MapView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-02-12.
//

import Foundation
import UIKit
import SwiftUI
import MapKit
import _MapKit_SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct MapView : View{
    @State var popUpIsShowing = false
    @State var showStartView : Bool = false
    @ObservedObject var gallerys: Gallerys = .shared
    
      @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 59.334591, longitude:  18.063240), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View{
        Text("oh, the places you´ll go...")
        
        ZStack{
           
            
            Map(coordinateRegion: $region,
                interactionModes: [.all],
                showsUserLocation: true,
                
                annotationItems: gallerys.myGalleries) { gallery in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: gallery.latitude, longitude: gallery.longitude), anchorPoint: CGPoint(x: 0.5, y: 0.5)){
                    
                    MapPinView(userName: gallery.userName)
                        .onTapGesture {
                            gallerys.selectedGallery = gallery
                            popUpIsShowing = true
                            //show info and button to load Map in AR
                            //loadMapFromStorage(name: gallery.userName)
                            
                            
                        }
                    
                }
                
            }
            
            if popUpIsShowing == true {
                popupInfo(userName: gallerys.selectedGallery.userName, mapName: gallerys.selectedGallery.worldMap, popUpIsShowing: $popUpIsShowing,  descriptopn: gallerys.selectedGallery.descriptonOfPlacement)
            }
           
            
            
        }.onAppear{
            
            listenToFirestoreForMaps()
        }
        
    }
    
    
    
    func listenToFirestoreForMaps() {
        
        
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        db.collection("WorldMaps").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                gallerys.myGalleries.removeAll()
                for document in snapshot.documents {
                    
                    let result = Result {
                        try document.data(as: Gallery.self)
                    }
                    switch result  {
                    case .success(let gallery)  :
                        gallerys.myGalleries.append(gallery)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
    struct popupInfo: View{
        @State var userName : String
        @State var mapName : String
        @Binding var popUpIsShowing : Bool
        
        @State var descriptopn : String
        var body: some View{
            
            ZStack{
             
                Color.white.opacity(0.30)
                    .frame(width: 200.0, height: 200.0, alignment: .center)
                    .cornerRadius(20.0)
                    .border(.black)
                    
                    .shadow(color: .black, radius: 20.0, x: 10.0, y: 10.0)
                
                VStack{
                    Text(mapName)
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                    
                    
                    
                    
                    
                    Text(descriptopn)
                        .foregroundColor(Color.black)
                    
                    Text("Creator: \(userName)")
                        .foregroundColor(Color.black)
                    
                    
                    //how to i go back to startView with the initializer of loadmapfrom storage with the clicked maps name?
                    
                    HStack{
                        Button(action: { popUpIsShowing = false
                            
                            
                            
                            
                            
                        }){
                            Text("OK")
                            
                        }
                        
                        
                        Button(action: {
                        //loadMapFromStorage(name: mapName)
                            
                            
                            
                            
                            print("you pressed load")
                            
                            
                            
                        }){
                            
                            Text("Visa platsen")
                        }
                        
                        
                        
                        
                        
                    }
                }.frame(width: 200.0, height: 200.0, alignment: .center)

                
            }
            
            
        }
        
    }
    func placePinsOnMap(){}
    struct MapPinView : View {
        @State var userName : String
        var body: some View{
            VStack{
                
                Image("art")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
               
            }
        }
    }
    


}
