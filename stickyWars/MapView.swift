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


struct MapView : UIViewRepresentable{
    typealias UIViewType = UIView
    
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView ()
        //here we create the map
        
        
        //59.34406889792089, 18.047007501292203
        
        
        let coordinate = CLLocationCoordinate2D(latitude: 59.34406889792089, longitude: 18.047007501292203)
        
        
        let map = MKMapView()
        map.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7) ), animated: true)
        
        
        view.addSubview(map)
        
        map.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            map.widthAnchor.constraint(equalTo: view.widthAnchor),
            map.heightAnchor.constraint(equalTo: view.heightAnchor),
            map.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            map.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        
        ])
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Do later
    }
    
    
   
    
    
    
    
    
}
