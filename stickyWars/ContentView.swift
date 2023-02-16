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
    @ObservedObject var collection: Collection = .shared
    @ObservedObject var gallerys: Gallerys = .shared
    @ObservedObject var locationManager : LocationManager = .shared
    
    @State var coordinator = Coordinator()
    // @Published var worldMapisSaved : Bool = false
    @State var showMapSheet = false
    @State var showPaintSheet = false
    @State var showPhotoGalleri = false
    @State var showMyCollectionSheet = false
    @State var canvas = PKCanvasView()
   /* @ObservedObject var sceneManager : SceneManager = .shared*/
    @ObservedObject var scenePersistenceHelper : ScenePersistenceHelper = .shared
    
    var body: some View{
        if userIsLoggedIn{
            content
        }else{
            LoginView(userIsLoggedIn: $userIsLoggedIn)
        }
        
    }
    
    
    
    var content: some View{
        
        
        
        
        
        ZStack(alignment: .bottom){
            
            
            VStack(){
                HStack{
                    alertForInput()
                    alertForOutput()
                    
                    
                    Button(action: {
                        showingAlert = true
                    }){
                        Image(systemName: "eye")
                    }
                    .foregroundColor(.black)
                    .frame(width: 60.0, height: 60.0, alignment: .center)
                    
                    
                    .alert("ARt är en app där du kan skapa dina konstverk och sedan placera ut dom i den virtuella verkligheten med hjälp av Augumented reality", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    
                    Button(action: {signOutUser()}){
                        Image(systemName: "person.fill.xmark")
                    }.foregroundColor(.black)
                        .frame(width: 55, height: 55, alignment: .center)
                    Button(action: {
                        showPaintSheet.toggle()
                        print("go to drawing")
                        
                    }){
                        //change to brush picture
                        Image(systemName: "paintbrush")
                            .cornerRadius(20.0)
                    }.foregroundColor(.black)
                        .frame(width: 50, height: 50, alignment: .center)
                    
                    
                        .sheet(isPresented: $showPaintSheet) {
                            Home(canvas: $canvas)
                        }
                    
                    Button(action: {
                        showMapSheet.toggle()
                        print("go to drawing")
                        
                    }){
                        //change to brush picture
                        Image(systemName: "map")
                            .cornerRadius(20.0)
                    }.foregroundColor(.black)
                        .frame(width: 50, height: 50, alignment: .center)
                    
                    
                        .sheet(isPresented: $showMapSheet) {
                            MapView()
                        }
                    
                    Button(action: {
                        showMyCollectionSheet.toggle()
                        print("go to collection")
                        
                    }){
                        //change to brush picture
                        Image(systemName: "backpack")
                    }.foregroundColor(.black)
                        .frame(width: 50.0, height: 50.0, alignment: .center)
                    
                    
                        .sheet(isPresented: $showMyCollectionSheet) {
                            MyCollectionView()
                        }
                    Button(action: {
                        showPhotoGalleri.toggle()
                    }){
                        Image(systemName: "photo")
                            
                    }.sheet(isPresented: $showPhotoGalleri) {
                        MyPhotoCollectionView()
                    }
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50, alignment: .center)
                    
                }.background(Color.yellow.opacity(0.200))
                    .cornerRadius(30)
                
                .padding()
                //Text("\(getEmal())").foregroundColor(.pink)
                //controllButtonBar()
                ARViewContainer()
                    .edgesIgnoringSafeArea(.all)
                    .cornerRadius(30)
                    .padding()
                    .background(LinearGradient(colors: [Color.yellow, Color.white.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing) )
                    .background(LinearGradient(colors: [Color.yellow.opacity(0.4), Color.pink.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .background(Color.white.opacity(0.2))
                
            }.background(LinearGradient(colors: [Color.orange.opacity(0.4), Color.yellow.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .background(LinearGradient(colors: [Color.orange.opacity(0.5), Color.yellow], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            
            
            
            modelPickerView(showPaintSheet: $showPaintSheet, coordinator: $coordinator, canvas: $canvas)
            
            
        }.onAppear(){
            
            listenForImagesToFirestore()
            listenForPhotosFirebase()
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
    
    
    
    struct alertForInput : View{
        @State var showingAlert = false
        @State var nameOfWorldMap : String = "worldMap"
        @State var descriptionOfPlacement : String = "on wall with stickers"
        var body: some View{
            
            Button("S") {showingAlert = true
                
                
                print("pressed save")
            }
            
            .alert("Name", isPresented: $showingAlert, actions: {
                TextField("your gallery", text: $nameOfWorldMap)
                    .foregroundColor(.pink)
                TextField("description of placement", text: $descriptionOfPlacement)
                
                
                Button("Save", action: {
                    
                    //saveusercurrentLocation
                    //save users email
                    
                    saveMapToFirebaseStorage(name: nameOfWorldMap)
                 saveInfoAboutMap(descriptionOfPlacement: descriptionOfPlacement, nameOfWorldMap: nameOfWorldMap)
                    
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("Please enter a name for your Gallery")
            })
            .buttonStyle(.bordered)
            
        }
        
        
    }
 
    struct alertForOutput : View{
        @State var showingAlert = false
        @State var nameOfWorldMap : String = "worldMap"
        var body: some View{
            
            Button("L") {showingAlert = true
                
                
                print("pressed load")
            }
            
            .alert("Name", isPresented: $showingAlert, actions: {
                TextField("your gallery", text: $nameOfWorldMap)
                    .foregroundColor(.pink)
                
                
                Button("Load", action: {
                    //this button should be placed at a pin at the map and the choosen pin should be tagged with the url to that worldMap
                    //FOREACH PIN ON MAP: take name on pin and load that worldMap in the ARVIEW
                    
                    loadMapFromStorage(name: nameOfWorldMap)
                    
                })
                Button("Cancel", role: .cancel, action: {})
            }, message: {
                Text("What Map do you want to see?")
            })
            .buttonStyle(.bordered)
            
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
func listenForImagesToFirestore() {
    @ObservedObject var collection: Collection = .shared
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    db.collection("Users").document("images").collection("Images").addSnapshotListener { snapshot, err in
        guard let snapshot = snapshot else {return}
        
        if let err = err {
            print("Error getting document \(err)")
        } else {
            collection.myCollection.removeAll()
            for document in snapshot.documents {
                
                let result = Result {
                    try document.data(as: Drawing.self)
                }
                switch result  {
                case .success(let drawing)  :
                    if drawing.id == user?.uid{
                        collection.myCollection.append(drawing)}
                case .failure(let error) :
                    print("Error decoding item: \(error)")
                }
            }
        }
    }
}

func listenForPhotosFirebase(){
    
    @ObservedObject var collection: Collection = .shared
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    db.collection("Users").document("photos").collection("Photos").addSnapshotListener { snapshot, err in
        guard let snapshot = snapshot else {return}
        
        if let err = err {
            print("Error getting document \(err)")
        } else {
            collection.myPhotoAlbum.removeAll()
            for document in snapshot.documents {
                
                let result = Result {
                    try document.data(as: Drawing.self)
                }
                switch result  {
                case .success(let drawing)  :
                    if drawing.id == user?.uid{
                    collection.myPhotoAlbum.append(drawing)
                    }
                case .failure(let error) :
                    print("Error decoding item: \(error)")
                }
            }
            
        }
        
    }
}

func loadMapFromStorage(name : String){
    
    @State var imageName : String =
    "https://firebasestorage.googleapis.com:443/v0/b/streetgallery-cd734.appspot.com/o/DE71BB65-C95B-47C1-8988-327D75D1B55F.jpeg?alt=media&token=36685c18-f837-4359-b09c-7a2505c7aaef"
    
    var anchorList : [String] = []
   
   
   
    @ObservedObject var coordinator : Coordinator = .shared
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    let path = name
    let fileRef = storageRef.child(path)
    let downLoadTask = fileRef.getData( maxSize: 10000000) { data, error in
        if error == nil && data != nil{
            
            let config = ARWorldTrackingConfiguration()
            
            if let unarchiver = try? NSKeyedUnarchiver.unarchivedObject(
                ofClasses: [ARWorldMap.classForKeyedUnarchiver()],
                from: data!),
               let worldMap = unarchiver as? ARWorldMap {
                print("seems to work")
                
                
                
                for anchor in worldMap.anchors{
                    
                    
                    anchorList.append(anchor.identifier.uuidString)
                    print(anchorList)
                    
                  
                    db.collection("Anchors").document(anchor.identifier.uuidString).getDocument() {
                        document, error in
                        
                        
                        let result = Result {
                            try document!.data(as: Anchors.self)
                                            }
                        switch result  {
                                            case .success(let document)  :
                            
                            
                            let mesh = MeshResource.generateBox(width: 0.5, height: 0.02, depth: 0.5)
                                
                                let box = ModelEntity(mesh: mesh)
                                box.generateCollisionShapes(recursive: true)
                                
                                
                            coordinator.loadPictureAsTextureSAved(box: box, view: ARViewContainer.ARVariables.arView, anchor: anchor, anchorName: document.image)
                                
                            
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


struct modelPickerView : View{
    @State var locationManager = LocationManager()
    @ObservedObject var collection: Collection = .shared
    @Binding var showPaintSheet : Bool
    @Binding var coordinator : Coordinator
    @Binding var canvas : PKCanvasView
    
    var body: some View{VStack{
        
        Button {
            
            // Placeholder: take a snapshot
            ARViewContainer.ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                
                // Compress the image
                let compressedImage = UIImage(data: (image?.pngData())!)
                // Save in the photo album¨
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
        ScrollView(.horizontal, showsIndicators: false){
            
            
            
            HStack(){
                ForEach(0..<collection.myCollection.count,id: \.self){
                    index in
                    
                    Button(action: {
                        print("You pressed \(collection.myCollection[index].name)")
                        
                        collection.selectedDrawing = collection.myCollection[index].url
                        
                    }){
                        let url = collection.myCollection[index].url
                        
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
                    .border(Color.pink.opacity(0.60), width: collection.selectedDrawing == collection.myCollection[index].url ? 5.0 : 0.0 )
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
func saveMapToFirebaseStorage(name : String ){
    
    ARViewContainer.ARVariables.arView.session.getCurrentWorldMap { (worldMap, _) in
        
        if let map: ARWorldMap = worldMap {
            
            let data = try! NSKeyedArchiver.archivedData(withRootObject: map,
                                                         requiringSecureCoding: true)
            
            let storageRef = Storage.storage().reference()
            let path = name
            let fileRef = storageRef.child(path)
            
            
            
            let uploadTask = fileRef.putData(data, metadata: nil) { metadata, error in
                if error == nil && metadata != nil{
                    
                    
                }
                
                
                
            }
        }
    }
}
func saveToFirebaseStorage(image : UIImage) {
    
    guard image != nil else {return
    }
    
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
                let drawing = Drawing(url: urlString, name: "photo", id: user!.uid)
                try? db.collection("Users").document("photos").collection("Photos").addDocument(from : drawing)
                
            }
        }
        
    }
    uploadTask.resume()
    
}












