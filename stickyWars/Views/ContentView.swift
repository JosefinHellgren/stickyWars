//
//  ContentView.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-01-10.
//

import SwiftUI
import RealityKit
import ARKit
import PencilKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import CoreLocation


struct StartView : View {
    
    @State var userIsLoggedIn = false
    @State private var showingAlert = false
    @ObservedObject var collection: ArtworkCollection = .shared
    @ObservedObject var gallerys: Gallerys = .shared
    @ObservedObject var locationManager : LocationManager = .shared
    @State var coordinator = Coordinator()
    @State var showMapSheet = false
    @State var showPaintSheet = false
    @State var showPhotoGalleri = false
    @State var showMyCollectionSheet = false
    @State var showUserInfoSheet = false
    @State var canvas = PKCanvasView()
    @State private var isDarkMode = false
    @State private var showScore = false
    
    
    var body: some View {
        if userIsLoggedIn{
            content
        } else {
            LoginView(userIsLoggedIn: $userIsLoggedIn)
        }
    }
    
    var content: some View {
        
        ZStack(alignment: .bottom){
            VStack(){
                HStack{
                    VStack{
                        HStack{
                            TopTapButton(sheetBool: $showUserInfoSheet, imageName: "person", action: {showUserInfoSheet.toggle()})
                                .sheet(isPresented: $showUserInfoSheet, content: { userInfoSwiftUIView()})
                            TopTapButton(sheetBool: $showPaintSheet, imageName: "paintbrush", action:{ showPaintSheet.toggle()})
                                .sheet(isPresented: $showPaintSheet, content: {DrawingView(canvas: $canvas)})
                            TopTapButton(sheetBool: $showMapSheet, imageName: "map", action: {showMapSheet.toggle()})
                                .sheet(isPresented: $showMapSheet, content: {MapView()})
                            TopTapButton(sheetBool: $showMyCollectionSheet, imageName: "backpack", action: {showMyCollectionSheet.toggle()})
                                .sheet(isPresented: $showMyCollectionSheet, content: {MyCollectionView()})
                            TopTapButton(sheetBool: $showPhotoGalleri, imageName: "photo", action: {showPhotoGalleri.toggle()})
                                .sheet(isPresented: $showPhotoGalleri, content: {MyPhotoCollectionView()})
                            
                            Button(action: {signOutUser()}){
                                Image(systemName: "person.fill.xmark")
                            }
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50, alignment: .center)
                            Toggle("", isOn: $isDarkMode)
                            
                        }
                        .background(Color.yellow.opacity(0.200))
                        .cornerRadius(30)
                        
                        HStack{
                            ArtworkSaveAlertView()
                            ArtworkLoaderAlertButton(coordinator: $coordinator)
                            Button(action: {
                                coordinator.removeAllAnchors()
                            })
                            {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 50.0, height: 50.0, alignment: .center)
                                    .foregroundColor(Color.purple)
                            }
                            .buttonStyle(.bordered)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.black, lineWidth: 1)
                        )
                    }
                }
                
                ARViewContainer()
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(30)
                    .padding()
                    .background(LinearGradient(colors: [Color.yellow, Color.white.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing) )
                    .background(LinearGradient(colors: [Color.yellow.opacity(0.4), Color.pink.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .background(Color.white.opacity(0.2))
                
            }
            .background(LinearGradient(colors: [Color.orange.opacity(0.4), Color.yellow.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .background(LinearGradient(colors: [Color.orange.opacity(0.5), Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
            .preferredColorScheme(isDarkMode ? .dark : .light)
            
            
            modelPickerView(showPaintSheet: $showPaintSheet, coordinator: $coordinator, canvas: $canvas)
        }
        .onAppear(){
            collection.listenForImagesToFirestore()
            collection.listenForPhotosFirebase()
            locationManager.startLocationUpdates()
            
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    userIsLoggedIn = true
                }
            }
        }
    }
    
    func signOutUser(){
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            userIsLoggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}


struct TopTapButton : View {
    @Binding var sheetBool : Bool
    let imageName : String
    var action : () -> Void
    
    var body: some View{
        Button(action: action
        ){
            Image(systemName: imageName)
                .cornerRadius(20.0)
        }
        .foregroundColor(.black)
        .frame(width: 50, height: 50, alignment: .center)
    }
}

struct ArtworkSaveAlertView : View {
    @ObservedObject var gallerys: Gallerys = .shared
    @ObservedObject var locationManager : LocationManager = .shared
    @ObservedObject var userModel = UserModel()
    let anchors = Anchors()
    @State var showingAlert = false
    @State var nameOfWorldMap : String = ""
    @State var descriptionOfPlacement : String = ""
    
    var body: some View{
        Button {
            showingAlert = true
        } label: {
            VStack{
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width: 50.0, height: 50.0, alignment: .center)
                    .foregroundColor(Color.purple)
            }
        }
        .alert("Save Artwork", isPresented: $showingAlert, actions: {
            TextField("your artwork", text: $nameOfWorldMap)
                .foregroundColor(.black)
            TextField("description of placement", text: $descriptionOfPlacement)
            
            Button("Save", action: {
                let userEmail = userModel.user?.email
                let location = locationManager.location
                gallerys.saveMapToFirebaseStorage(name: nameOfWorldMap)
                
//                if let location, let userEmail {
////                    saveInfoAboutMap(descriptionOfPlacement: descriptionOfPlacement, nameOfWorldMap: nameOfWorldMap, coordinate: location)
//                    anchors.saveInfoAboutMap(userEmail: userEmail, descriptionOfPlacement: descriptionOfPlacement, nameOfWorldMap: nameOfWorldMap, coordinate: location)
//                }
                saveInfoAboutMap(descriptionOfPlacement: descriptionOfPlacement, nameOfWorldMap: nameOfWorldMap)
            })
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Choose a name for the artwork you placed at this location")
        }).buttonStyle(.bordered)
    }
}

struct ArtworkLoaderAlertButton : View {
    @Binding var coordinator : Coordinator
    @State var showingAlert = false
    @State var nameOfWorldMap : String = ""
    var anchors = Anchors()
    
    var body: some View {
        
        Button {
            showingAlert = true
        } label: {
            VStack{
                Image(systemName: "binoculars.fill")
                    .resizable()
                    .frame(width: 50.0, height: 50.0, alignment: .center)
                    .foregroundColor(Color.purple)
            }
        }
        .alert("Load Artwork", isPresented: $showingAlert, actions: {
            TextField("Artwork name", text: $nameOfWorldMap)
                .foregroundColor(.black)
            Button("Load", action: {
                anchors.loadAnchorFromStorage(name: nameOfWorldMap, coordinator: coordinator)
            })
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Write the name of the artwork you wanna load, be sure to be at the same location and read the description of where the artist placed the art.")
        })
        .buttonStyle(.bordered)
    }
}

struct Snapshot: View {
    @ObservedObject var collection: ArtworkCollection = .shared
    
    var body: some View {
        Button {
           
                ARViewContainer.ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                    guard let snapshotImage = image else {
                        return
                    }
                    
                    if let compressedImageData = snapshotImage.pngData() {
                        let compressedImage = UIImage(data: compressedImageData)
                        if let compressedImage = compressedImage {
                            collection.savePhotoToFirebaseStorage(image: compressedImage)
                            UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
                        }
                    }
                }
        } label: {
            Image(systemName: "camera")
                .frame(width: 60, height: 60)
                .font(.title)
                .background(Color.white.opacity(0.75))
                .cornerRadius(30)
                .padding()
        }
    }
}

struct modelPickerView : View {
    @State var locationManager = LocationManager()
    @ObservedObject var collection: ArtworkCollection = .shared
    @Binding var showPaintSheet : Bool
    @Binding var coordinator : Coordinator
    @Binding var canvas : PKCanvasView
    let db = Firestore.firestore()
    
    var body: some View{
        VStack{
            Snapshot()
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(){
                    ForEach(0..<collection.myDrawings.count,id: \.self) {
                        index in
                        
                        Button(action: {
                            collection.selectedDrawing = collection.myDrawings[index].url
                        }){
                            let url = collection.myDrawings[index].url
                            
                            AsyncImage(url: URL(string: url))
                            { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .opacity(0.70)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        .cornerRadius(20.0)
                        .border(Color.pink.opacity(0.60), width: collection.selectedDrawing == collection.myDrawings[index].url ? 5.0 : 0.0 )
                        .cornerRadius(20.0)
                    }
                }
                .background(Color.white.opacity(0.25))
                .padding()
            }
        }
    }
}

func saveInfoAboutMap( descriptionOfPlacement : String , nameOfWorldMap : String){
    @ObservedObject var locationManager : LocationManager = .shared
    let db = Firestore.firestore()
    @ObservedObject var gallerys: Gallerys = .shared
    //create GalleryObject
    //users current location
    let usersEmail = Auth.auth().currentUser?.email ?? "generic email adress"
    
    
   
    locationManager.startLocationUpdates()
    
    print(locationManager.location?.latitude)
    
    
    print(gallerys.myGalleries)
    
    
    let map = Gallery(worldMap: nameOfWorldMap, longitude: locationManager.location?.longitude ??  18.0371209, latitude: locationManager.location?.latitude ??     59.34222, descriptionOfPlacement: descriptionOfPlacement, userName: usersEmail)

    do {
        _ = try db.collection("WorldMaps").addDocument(from: map)
    } catch {
        print("Error saving to DB")
    }

    
}

