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
    
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(
//            latitude: 43.64422936785126, longitude: 142.39329541313924
//        ),
//        span: MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 2)
//    )
    
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
//        view.setRegion(region, animated: false)
        view.mapType = .standard
        view.addAnnotations(places)
        
        return view
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
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
