//
//  ScenePersistenceHelper.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-01-25.
//

import Foundation
import RealityKit
import ARKit

class ScenePersistenceHelper : ObservableObject{
    
    static let shared = ScenePersistenceHelper ()
    
    class func saveScene(for arView : ARView, at persistenceUrl : URL){
        
        arView.session.getCurrentWorldMap{ worldMap, error in
            guard let map = worldMap else{
                
                print("persistence error, unable to get worldMap\(error?.localizedDescription)")
                return
                
            
            }
            do{
                
                let sceneData = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try sceneData.write(to: persistenceUrl , options: [.atomic])
            }catch {
                print("errror när vi försökte spara datan")
                
            }
        }
        print("save scene")
    }
    class func loadScene(for arView : ARView, with scenePersistenceData : Data){
        var arView = ARView ()
        print("load scene")
        
        let worldMap : ARWorldMap = {
            do{
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: scenePersistenceData) else{
                    fatalError("o hej vad fel det blev att loada skiten")
                    
                    
                }
                return worldMap
            }catch{
                fatalError("fel igen")
            }
        }()
        /*let newConfig = arView.defaultConfiguration
        newConfig.initialWorldMap = worldMap
        arView.session.run(newConfig,options: [.resetTracking, .removeExistingAnchors])*/
        
    }
}
