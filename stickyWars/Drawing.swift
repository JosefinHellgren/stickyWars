//
//  Drawings.swift
//  stickyWars
//
//  Created by josefin hellgren on 2023-01-26.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import FirebaseFirestore

class Drawing : Encodable, Decodable{
    
    let url : String
    let name : String
    
    init(url : String, name : String){
        self.url = url
        self.name = name
    }
}

