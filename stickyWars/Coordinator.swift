//
//  Coordinatior.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-01-19.
//

import Foundation
import ARKit
import RealityKit
import UIKit
import Combine
import SwiftUI

class Coordinator : NSObject , ARSessionDelegate {
    @ObservedObject var sceneManager : SceneManager = .shared
  
    var arView : ARView?
    

    weak var view : ARView?
    
    @objc func handleTap(recognizer : UITapGestureRecognizer){
       
        
        
        guard let view = self.view else {return }
        
        let tapLocation = recognizer.location(in: view)
        
        let results =   view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .vertical)
        if let results = results.first{
            print("tapped arview")
            
            let anchor = ARAnchor(name: "Plane Anchor", transform: results.worldTransform)
            view.session.add(anchor: anchor)
            
            self.sceneManager.anchorEntitys.append(anchor)
            let mesh = MeshResource.generateBox(width: 0.5, height: 0.02, depth: 0.5)
            
            let box = ModelEntity(mesh: mesh)
            box.generateCollisionShapes(recursive: true)
           
            
            loadPictureAsTexture(box: box, view: view, anchor: anchor)
            
        }
        
    }
 
  
    
    func loadPictureAsTexture(box : ModelEntity, view: ARView, anchor : ARAnchor){
        @ObservedObject var collection: Collection = .shared
        
        let urlTest = collection.selectedDrawing
    
        
   
        guard let imageURL = URL(string: urlTest) else { return }
        
        let session = URLSession(configuration: .default).dataTask(with: imageURL) {
            imageData, response, error in
            
            if let data = imageData {
                
                DispatchQueue.main.async {
                    
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let filePath = documentsDirectory.appendingPathComponent("sky.png")
                    try? data.write(to: filePath)
                    let texture = try? TextureResource.load(contentsOf: filePath)
                    
                    if let texture = texture {
                        
                        var material = UnlitMaterial()
                        material.color = .init(tint: .white, texture : .init(texture))
                        box.model?.materials = [material]
                        
                        
                        let anchorentety = AnchorEntity(anchor: anchor)
                        anchorentety.addChild(box)
                        view.scene.addAnchor(anchorentety)
                        view.installGestures(.all, for: box)
                        
                    }
                }
            }
        }
        session.resume()
    }
    
}

