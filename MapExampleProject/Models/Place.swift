//
//  Place.swift
//  MapExampleProject
//
//  Created by Karina gurachevskaya on 23.11.22.
//

import Foundation
import MapKit

struct Place: Decodable {
    let name: String
    let location: CLLocationCoordinate2D
    
    init(from decoder: Decoder) throws {
        enum CodingKey: Swift.CodingKey {
            case name
            case latitude
            case longitude
        }
        
        let values = try decoder.container(keyedBy: CodingKey.self)
        name = try values.decode(String.self, forKey: .name)
        let latitude = try values.decode(Double.self, forKey: .latitude)
        let longitude = try values.decode(Double.self, forKey: .longitude)
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //      region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    }
}

class PlaceAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.coordinate = coordinate
    }
}
