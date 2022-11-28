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
    @Binding var currentLocation : CLLocationCoordinate2D
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? PlaceAnnotation else { return nil }
            return AnnotationView(annotation: annotation, reuseIdentifier: AnnotationView.reuseID)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        MapView.Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        view.mapType = .standard
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if places.count != uiView.annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(places)
        }
        uiView.showsUserLocation = true
        uiView.setCenter(currentLocation, animated: true)
    }
    
    //    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    //        if !mapView.showsUserLocation {
    //            parent.centerCoordinate = mapView.centerCoordinate
    //        }
    //    }
}

class AnnotationView: MKMarkerAnnotationView {
    
    static let reuseID = "annotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "clustering"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
    }
}
