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
    
    
    var body: some View{
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
                            
                            topButton(sheetBool: $showUserInfoSheet, imageName: "person", action: {showUserInfoSheet.toggle()})
                                .sheet(isPresented: $showUserInfoSheet, content: { userInfoSwiftUIView()})
                            
                            topButton(sheetBool: $showPaintSheet, imageName: "paintbrush", action:{ showPaintSheet.toggle()})
                                .sheet(isPresented: $showPaintSheet, content: {drawingView(canvas: $canvas)})
                            
                            topButton(sheetBool: $showMapSheet, imageName: "map", action: {showMapSheet.toggle()})
                                .sheet(isPresented: $showMapSheet, content: {MapView()})
                            topButton(sheetBool: $showMyCollectionSheet, imageName: "backpack", action: {showMyCollectionSheet.toggle()})
                                .sheet(isPresented: $showMyCollectionSheet, content: {MyCollectionView()})
                            
                            topButton(sheetBool: $showPhotoGalleri, imageName: "photo", action: {showPhotoGalleri.toggle()})
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
                            
                            alertForInput()
                            alertForOutput(coordinator: $coordinator)
                            Button(action: {
                                coordinator.removeAllAnchors()
                                
                            })
                            {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 50.0, height: 50.0, alignment: .center)
                                    .foregroundColor(Color.purple)
                                
                                
                            }.buttonStyle(.bordered)
                            
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
                
            }.background(LinearGradient(colors: [Color.orange.opacity(0.4), Color.yellow.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .background(LinearGradient(colors: [Color.orange.opacity(0.5), Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
                .preferredColorScheme(isDarkMode ? .dark : .light)
            
            
            modelPickerView(showPaintSheet: $showPaintSheet, coordinator: $coordinator, canvas: $canvas)
        }
        
        .onAppear(){
            
            collection.listenForImagesToFirestore()
            collection.listenForPhotosFirebase()
            locationManager.startLocationUpdates()
            
            Auth.auth().addStateDidChangeListener
            {
                auth , user in
                if user != nil{
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


struct topButton : View{
    @Binding var sheetBool : Bool
    let imageName : String
    var action : () -> Void
    var body: some View{
        
        
        Button(action: action
        ){
            
            Image(systemName: imageName)
                .cornerRadius(20.0)
        }.foregroundColor(.black)
            .frame(width: 50, height: 50, alignment: .center)
    }
}

struct alertForInput : View{
    @ObservedObject var gallerys: Gallerys = .shared
    @State var showingAlert = false
    @State var nameOfWorldMap : String = ""
    @State var descriptionOfPlacement : String = ""
    var body: some View{
        
        Button{showingAlert = true
            
            
            print("pressed save")
        } label: { VStack{Image(systemName: "mappin.and.ellipse")
            
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
                
                
                
                gallerys.saveMapToFirebaseStorage(name: nameOfWorldMap)
                saveInfoAboutMap(descriptionOfPlacement: descriptionOfPlacement, nameOfWorldMap: nameOfWorldMap)
                
            })
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Choose a name for the artwork you placed at this location")
        }).buttonStyle(.bordered)
        
        
    }
    
    
}


struct alertForOutput : View{
    @State var showingAlert = false
    @Binding var coordinator : Coordinator
    @State var nameOfWorldMap : String = ""
    var body: some View{
        
        Button{showingAlert = true
            
            
            print("pressed load")
        } label: { VStack{
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
                
                
                loadMapFromStorage(name: nameOfWorldMap)
                
            })
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Write the name of the artwork you wanna load, be sure to be at the same location and read the description of where the artist placed the art.")
        }).buttonStyle(.bordered)
        
        
    }
}

func loadMapFromStorage(name : String){
    @ObservedObject var coordinator : Coordinator = .shared
    @State var imageName : String =
    "https://firebasestorage.googleapis.com:443/v0/b/streetgallery-cd734.appspot.com/o/DE71BB65-C95B-47C1-8988-327D75D1B55F.jpeg?alt=media&token=36685c18-f837-4359-b09c-7a2505c7aaef"
    
    var anchorList : [String] = []
    
    
    
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let path = name
    let fileRef = storageRef.child(path)
    _ = fileRef.getData( maxSize: 10000000) { data, error in
        if error == nil && data != nil{
            
            let config = ARWorldTrackingConfiguration()
            
            if let unarchiver = try? NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [ARWorldMap.classForKeyedUnarchiver()],
                from: data!),
               let worldMap = unarchiver as? ARWorldMap {
                print("seems to work")
                
                
                
                for anchor in worldMap.anchors{
                    
                    
                    anchorList.append(anchor.identifier.uuidString)
                    db.collection("Anchors").document(anchor.identifier.uuidString).getDocument() { document, error in
                        
                        let result = Result {
                            try document!.data(as: Anchor.self)
                        }
                        switch result  {
                        case .success(let document)  :
                            
                            
                            let mesh = MeshResource.generateBox(width: 0.5, height: 0.02, depth: 0.5)
                            
                            let box = ModelEntity(mesh: mesh)
                            box.generateCollisionShapes(recursive: true)
                            
                            
                            coordinator.loadPictureAsTextureOnMap(box: box, view: ARViewContainer.ARVariables.arView, anchor: anchor, anchorName: document.image)
                            
                            
                            config.initialWorldMap = worldMap
                            config.planeDetection = .vertical
                            ARViewContainer.ARVariables.arView.session.run(config)
                        case .failure(let error) :
                            print("Error decoding item: \(error)")
                        }
                        
                    }
                    
                    
                    
                    
                    
                }
            }
        }else{
            
            
        }
    }
    
}

struct snapShot : View{
    var body: some View{
        
        Button {
            
            ARViewContainer.ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                
                
                let compressedImage = UIImage(data: (image?.pngData())!)
                
                saveToFirebaseStorage(image: compressedImage!)
                
                UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
            }
            
        } label: {
            Image(systemName: "camera")
                .frame(width:60, height:60)
                .font(.title)
                .background(.white.opacity(0.75))
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
    
    var body: some View{VStack{

        snapShot()
        ScrollView(.horizontal, showsIndicators: false){
            
            HStack(){
                ForEach(0..<collection.myDrawings.count,id: \.self){
                    index in
                    
                    Button(action: {
                        print("You pressed \(collection.myDrawings[index].name)")
                        
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
            }.background(Color.white.opacity(0.25))
                .padding()
        }
    }
    }
}

func saveInfoAboutMap( descriptionOfPlacement : String , nameOfWorldMap : String){
    @ObservedObject var locationManager : LocationManager = .shared
    @ObservedObject var gallerys: Gallerys = .shared
    @ObservedObject var userModel = UserModel()
    let userEmail = userModel.user?.email
    let db = Firestore.firestore()
    
    locationManager.startLocationUpdates()
    
    if let userEmail = userEmail {
        let map = Gallery(worldMap: nameOfWorldMap, longitude: locationManager.location?.longitude ??  18.0371209, latitude: locationManager.location?.latitude ??     59.34222, descriptionOfPlacement: descriptionOfPlacement, userName: userEmail)
        do {
            _ = try db.collection("WorldMaps").addDocument(from: map)
        } catch {
            print("Error saving to DB")
        }
        
    }
    
    

    
}

func saveToFirebaseStorage(image : UIImage) {
    
    guard image != nil else {return}
    
    let storageRef = Storage.storage().reference()
    let imageData = image.jpegData(compressionQuality: 0.8)
    guard imageData != nil else{return}
    
    
    
    let path = "photo\(UUID().uuidString).jpeg"
    
    
    let fileRef = storageRef.child(path)
    
    let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
        
        if error == nil && metadata != nil{
            
            
        }
        fileRef.downloadURL {
            url, error in
            
            if let url = url {
                
                let db = Firestore.firestore()
                let urlString = url.absoluteString
                let user = Auth.auth().currentUser
                let drawing = Artwork(url: urlString, name: "photo", id: user!.uid)
                try? db.collection("Users").document("photos").collection("Photos").addDocument(from : drawing)
                
            }
        }
        
    }
    uploadTask.resume()
}













