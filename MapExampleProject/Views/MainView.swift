//
//  MapView.swift
//  MapExampleProject
//
//  Created by Karina gurachevskaya on 23.11.22.
//

import SwiftUI
import MapKit

struct MainView: View {
    let places: [Place]
    
    init(places: [Place]) {
        self.places = places
    }
    
    @StateObject private var locationManager = LocationManager()
    @State private var locationError: Error?
    @State private var currentLocation = CLLocationCoordinate2D()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(places: mapPlaces(places), currentLocation: $currentLocation)
                .edgesIgnoringSafeArea(.all)
            
            Button {
                withAnimation {
                    getCurrentLocation()
                }
            } label: {
                Label {
                    Text("Current Location")
                } icon: {
                    Image(systemName: "location.fill")
                }
            }
            .frame(width: 180, height: 40)
            .background(Color.blue)
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
        }
        .onReceive(locationManager.$isAuthorized, perform: { newValue in
            locationError = newValue == false ? LocationError.notAuthorized : nil
        })
        .onReceive(locationManager.$location, perform: { newValue in
            if let newValue = newValue {
                currentLocation = newValue
            }
        })
        .errorAlert(error: $locationError)
        .onAppear {
            locationManager.requestLocation()
        }
    }
    
    private func mapPlaces(_ places: [Place]) -> [PlaceAnnotation] {
        places.map {
            PlaceAnnotation(title: $0.name, coordinate: $0.location)
        }
    }
    
    func getCurrentLocation() {
        if !locationManager.isAuthorized {
//            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
        if let location = locationManager.location {
            currentLocation = location
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(places: MapDirectory().places)
    }
}

enum LocationError: LocalizedError, Equatable {
    case notAuthorized
    
    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Missing title"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .notAuthorized:
            return "Article publishing failed due to missing title"
        }
    }
}

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
