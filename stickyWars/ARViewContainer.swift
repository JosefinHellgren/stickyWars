//
//  ARViewContainer.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-01-25.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit


struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var collection: Collection = .shared
    /*@ObservedObject var sceneManager : SceneManager = .shared*/

   
    

 
    
    func makeUIView(context: Context) -> ARView {
        @ObservedObject var collection: Collection = .shared
        
        
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            fatalError("People occlusion is not supported on this device.")
        }
        
        
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical, .horizontal]
        config.environmentTexturing = .automatic
        config.isCollaborationEnabled = true
        
        config.frameSemantics.insert(.personSegmentationWithDepth)
       
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            config.sceneReconstruction = .mesh
            
        }
       
        ARVariables.arView = ARView(frame: .zero)
        
        
        
        ARVariables.arView.addCoaching()
      
       
        ARVariables.arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
    
       
        context.coordinator.view = ARVariables.arView
        ARVariables.arView.session.delegate = context.coordinator
        ARVariables.arView.session.run(config)
      
        
        /*self.updatePersistanceAvailability(arView: ARVariables.arView)
        self.handlePersistence(arView: ARVariables.arView)*/
        
        return ARVariables.arView
    
    }
    func makeCoordinator() -> Coordinator{
        Coordinator( )
    }
   
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        
          
}
    struct ARVariables{
      static var arView: ARView!
    }
   
    }
/*class SceneManager  : ObservableObject{
    
    static let shared = SceneManager()
    @Published var isPersistanceAvailable : Bool = false
    @Published var anchorEntitys : [ARAnchor] = [] // keeps track of the anchors in the scene, with model Entetys.
    var shouldSaveSceneToFileSystem : Bool = false
    var shouldLoadSceneFromFileSystem : Bool = false
    
    lazy var persistenceUrl : URL = {
       
        do{
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("arf.persistence")
            
        }catch{
            fatalError("unable to get persistence Url\(error.localizedDescription)")
            
            
            
        }
    }()
    
    var scenePersistenceData : Data? {
        return try?  Data(contentsOf: persistenceUrl)
    }
}
extension ARViewContainer{
    private func updatePersistanceAvailability(arView : ARView){
        guard let currentFrame = arView.session.currentFrame else{
            
            print("ARframe is not availbale")
            return
        }
        switch currentFrame.worldMappingStatus {
        case .mapped , .extending :
            self.sceneManager.isPersistanceAvailable = !self.sceneManager.anchorEntitys.isEmpty
        default :
            self.sceneManager.isPersistanceAvailable = false
        }
        
    }
    private func handlePersistence (arView: ARView){
        
        if self.sceneManager.shouldSaveSceneToFileSystem{
            ScenePersistenceHelper.saveScene(for: arView, at: self.sceneManager.persistenceUrl)
            self.sceneManager.shouldSaveSceneToFileSystem = false
            
        }else if self.sceneManager.shouldLoadSceneFromFileSystem {
            
            guard let scenePersistenceData = self.sceneManager.scenePersistenceData else{
                
                print("Unable to retrieve scenePersistenceData. canceled loadScene operation")
                self.sceneManager.shouldLoadSceneFromFileSystem = false
                return
            }
            ScenePersistenceHelper.loadScene(for: arView, with: scenePersistenceData)
            self.sceneManager.anchorEntitys.removeAll(keepingCapacity: true)
            self.sceneManager.shouldLoadSceneFromFileSystem = false
        }
    }
    
    
    
}*/
