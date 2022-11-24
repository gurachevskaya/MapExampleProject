//
//  MapView.swift
//  MapExampleProject
//
//  Created by Karina gurachevskaya on 23.11.22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
//    let location: Place
//    let places: [Place]
    
    @StateObject private var locationManager = LocationManager()
    @Environment(\.presentationMode) private var presentationMode
    @State private var locationError: Error?
//    init(location: Place, places: [Place]) {
//        self.location = location
//        self.places = places
//    }
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
            //        { item in
            //        MapAnnotation(coordinate: item.location.coordinate) {
            //          VStack {
            //            Circle()
            //              .fill(Color.red)
            //            Text(item.name)
            //              .fontWeight(.bold)
            //          }
            //        }
            //      }
        }
        .onReceive(locationManager.$isAuthorized, perform: { newValue in
            locationError = newValue == false ? LocationError.notAuthorized : nil
        })
//        .onChange(of: locationManager.$isAuthorized, perform: { newValue in
//            if newValue == false {
//                locationError = LocationError.notAuthorized
//            }
//        })
        .errorAlert(error: $locationError)
        .onAppear {
            locationManager.requestLocation()
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
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
