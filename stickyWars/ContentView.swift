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
import GameController



struct ContentView : View {
   
    @State var isSignedIn = false
    

    
    
    
    var body: some View {
        if !isSignedIn{
            LoginView(isSignedIn: $isSignedIn)
        }else{
            StartView()
        }

    }
}

struct StartView : View {
    @State var isSignedIn : Bool = false
   
    @State private var showingAlert = false
    @ObservedObject var collection: Collection = .shared
    @State var coordinator = Coordinator()
    @State var myCollection = [UIImage]()
    @State var showPaintSheet = false
    @State var showPhotoGalleri = false
    @State var showMyCollectionSheet = false
    @State var canvas = PKCanvasView()
    @ObservedObject var sceneManager : SceneManager = .shared
    @ObservedObject var scenePersistenceHelper : ScenePersistenceHelper = .shared
    
   var body: some View{
    ZStack(alignment: .bottom){
       
    
        VStack(){
            HStack{
                
                Button(action: {
                    showPhotoGalleri.toggle()
                }){
                    Image(systemName: "photo")
                }.sheet(isPresented: $showPhotoGalleri) {
                    MyPhotoCollectionView()
                }
                .foregroundColor(.pink)
                .frame(width: 40, height: 40, alignment: .center)
                Button(action: { print("shit")
                  
                }){
                    Image(systemName: "square.and.arrow.up")
                    
                }.foregroundColor(.pink)
                    .frame(width: 40, height: 40, alignment: .center)
                
                Button(action: { //should be the load button
                  
                }){
                  Image(systemName: "square.and.arrow.down")
                    
                }.foregroundColor(.pink)
                    .frame(width: 40, height: 40, alignment: .center)
                Spacer()
                Button("ARt") {
                    showingAlert = true
                }
                .foregroundColor(.pink)
                .frame(width: 40.0, height: 40.0, alignment: .center)
                
                
                .alert("ARt är en app där du kan skapa dina konstverk och sedan placera ut dom i den virtuella verkligheten med hjälp av Augumented reality", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
            Spacer()
            Button(action: {
                showPaintSheet.toggle()
                print("go to drawing")
                
            }){
                //change to brush picture
               Image(systemName: "paintbrush")
                    .cornerRadius(20.0)
            }.foregroundColor(.pink)
                    .frame(width: 40, height: 40, alignment: .center)
                    
          
                .sheet(isPresented: $showPaintSheet) {
                    Home(canvas: $canvas)
                }
                Spacer()
               
                
                Button(action: {
                    showMyCollectionSheet.toggle()
                    print("go to collection")
                    
                }){
                    //change to brush picture
                 Image(systemName: "backpack")
                }.foregroundColor(.pink)
                    .frame(width: 40.0, height: 40.0, alignment: .center)
                    Spacer()
              
                    .sheet(isPresented: $showMyCollectionSheet) {
                        MyCollectionView()
                    }
                
            }.padding()
            //Text("\(getEmal())").foregroundColor(.pink)
            //controllButtonBar()
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
         
        }
       
       
        
        modelPickerView(showPaintSheet: $showPaintSheet, coordinator: $coordinator, canvas: $canvas)
        
        
    }.onAppear(){
        listenToFirestore()
        listenForPhotosFirebase()
    }
    
}
    


    }
func listenToFirestore() {
    @ObservedObject var collection: Collection = .shared
    
    let db = Firestore.firestore()
        db.collection("Images").addSnapshotListener { snapshot, err in
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
                        collection.myCollection.append(drawing)
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
        db.collection("Photos").addSnapshotListener { snapshot, err in
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
                        collection.myCollection.append(drawing)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            
        }
        
}
    func sSaveWorldMap() {

        ARViewContainer.ARVariables.arView.session.getCurrentWorldMap { (worldMap, _) in
            
            if let map: ARWorldMap = worldMap {
                
                let data = try! NSKeyedArchiver.archivedData(withRootObject: map,
                                                      requiringSecureCoding: true)
                print("found a map")
                
                let savedMap = UserDefaults.standard
                savedMap.set(data, forKey: "WorldMap")
                savedMap.synchronize()
            }
        }
    }
    
    func loadWorldMap() {
        let config = ARWorldTrackingConfiguration()
        

        let storedData = UserDefaults.standard

        if let data = storedData.data(forKey: "WorldMap") {
            print("found map")

            if let unarchiver = try? NSKeyedUnarchiver.unarchivedObject(
                                   ofClasses: [ARWorldMap.classForKeyedUnarchiver()],
                                        from: data),
               let worldMap = unarchiver as? ARWorldMap {

                config.initialWorldMap = worldMap
                ARViewContainer.ARVariables.arView.session.run(config)
            }
        }
    }
   
 
}
    





struct modelPickerView : View{
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
                            .frame(width: 70, height: 70)
                            .opacity(0.70)
                                
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                .cornerRadius(20.0)
                                .border(Color.green.opacity(0.60), width: collection.selectedDrawing == collection.myCollection[index].url ? 5.0 : 0.0 )
                            
                        }
                        
                        
                }.background(Color.pink.opacity(0.25))
               
                    
                
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
                        let drawing = Drawing(url: urlString, name: "photo")
                        try? db.collection("Photos").addDocument(from : drawing)
                       
                    }
                }
                
            }
            uploadTask.resume()

        }
        
    
    struct saveAndLoadButtons : View{
        @ObservedObject var sceneManager : SceneManager = .shared
        @ObservedObject var scenePersistenceHelper : ScenePersistenceHelper = .shared
        
        var body: some View{
            
            Button(action: {print("you pressed save")
                
                
                
                
                
            }){
                Image(systemName: "icloud.and.arrow.up")
                
            }
            
            
            Button(action: {print("you pressed load")
                
                    
                
            }){
                
                Image(systemName: "icloud.and.arrow.down")
            }
            
            
            
            
        
    }
    struct controllButtonBar : View{
        
        var body: some View{
            
            HStack(alignment: .center){
                
                saveAndLoadButtons()
                
            }.frame(maxWidth:500)
                .padding(30)
                .background(Color.red.opacity(0.25))
        }
        
        
    }
   
    
    }
    

    
    
