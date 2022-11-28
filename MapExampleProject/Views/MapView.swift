//
//  CustomMap.swift
//  MapExampleProject
//
//  Created by Karina gurachevskaya on 24.11.22.
//

import MapKit
import SwiftUI
import Combine

struct MapView: UIViewRepresentable {
    
    private let view = MKMapView()

    var places: [PlaceAnnotation]
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        private var lastUserLocation: CLLocationCoordinate2D?
        private var cancellables: Set<AnyCancellable> = []
        
        init(_ parent: MapView) {
            self.parent = parent
            super.init()
            
            subscribeToLocationUpdates()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? PlaceAnnotation else { return nil }
            return AnnotationView(annotation: annotation, reuseIdentifier: AnnotationView.reuseID)
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            lastUserLocation = userLocation.coordinate
        }
        
        private func subscribeToLocationUpdates() {
            NotificationCenter.default.publisher(for: .goToCurrentLocation)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] output in
                    guard let lastUserLocation = self?.lastUserLocation else { return }
                    self?.parent.view.setCenter(lastUserLocation, animated: true)
                }
                .store(in: &cancellables)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        MapView.Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        view.delegate = context.coordinator
        view.mapType = .standard
        view.showsUserLocation = true
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
