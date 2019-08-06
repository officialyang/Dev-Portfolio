//
//  CustomAnnotation.swift
//  CSE438-MatthewYang
//
//  Created by Brandon Lum on 11/12/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let sub: String
    let coordinate: CLLocationCoordinate2D
    let object: String? // bathroom or water fountain
    
    init(title: String, sub: String,coordinate: CLLocationCoordinate2D, object: String) {
        self.title = title
        self.sub = sub
        self.coordinate = coordinate
        self.object = object
        
        super.init()
    }
    
    var subtitle: String? {
        return sub
    }
    
    
    var markerColor: UIColor  {
        if (object=="Water Fountain"){
            return .blue
        }
        else if (object=="Bathroom"){
            return .red
        }
        return .red
    }//markerColor
    
    var imageName: String? {
        if object == "Bathroom" { return "toilet (2)" }
        return "fountain"
    }
    
}
