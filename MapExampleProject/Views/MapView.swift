//
//  CustomMap.swift
//  MapExampleProject
//
//  Created by Karina gurachevskaya on 24.11.22.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    var places: [PlaceAnnotation]

    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
        view.delegate = context.coordinator
        
        view.addAnnotations(places)
    }
}

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    
    var mapViewController: MapView

    init(_ control: MapView) {
        self.mapViewController = control
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotation")
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
            annotationView?.canShowCallout = true
        }
        
        return annotationView
    }
}
