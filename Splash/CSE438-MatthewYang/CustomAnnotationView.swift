//
//  CustomAnnotationView.swift
//  CSE438-MatthewYang
//
//  Created by Brandon Lum on 12/3/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotationView: MKMarkerAnnotationView {

   
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? CustomAnnotation else { return }
            canShowCallout = true
            //calloutOffset = CGPoint(x: 0, y: -15)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = annotation.markerColor
            
            if let imageName = annotation.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
        }
    }// annotaion
    
    
    
}
