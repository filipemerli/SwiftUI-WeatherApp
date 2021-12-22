//
//  MapView.swift
//  SimpleWeather
//
//  Created by Felipe Merli on 09/12/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    private let coordinates: CLLocationCoordinate2D
    
    init(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        view.addAnnotation(annotation)
        
        view.setRegion(region, animated: true)
    }
}
