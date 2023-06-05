//
//  Anchors.swift
//  stickyWars
//
//  Created by Elin Simonsson on 2023-06-05.
//

import Foundation
import RealityKit
import ARKit
import PencilKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import CoreLocation

struct Anchors {
    
    
    
    func loadAnchorFromStorage(name : String, coordinator: Coordinator) {
        
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
                    
                    for anchor in worldMap.anchors {
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
            }
        }
    }
    
    func saveInfoAboutMap(userEmail: String, descriptionOfPlacement : String , nameOfWorldMap : String, coordinate: CLLocationCoordinate2D) {
        
        let longitude = coordinate.longitude
        let latitude = coordinate.latitude
        let db = Firestore.firestore()
       
            let map = Gallery(worldMap: nameOfWorldMap, longitude: longitude, latitude: latitude, descriptionOfPlacement: descriptionOfPlacement, userName: userEmail)
            do {
                _ = try db.collection("WorldMaps").addDocument(from: map)
            } catch {
                print("Error saving to DB")
            }
        
    }
}
