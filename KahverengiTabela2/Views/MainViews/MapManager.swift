//
//  MapView.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu 
//

import SwiftUI
import MapKit

struct MapManager: UIViewRepresentable{
    @Binding var route: MKPolyline?
        let mapViewDelegate = MapManagerDelegate()

        func makeUIView(context: Context) -> MKMapView {
            MKMapView(frame: .zero)
        }

        func updateUIView(_ view: MKMapView, context: Context) {
            view.delegate = mapViewDelegate
            view.translatesAutoresizingMaskIntoConstraints = false 
            addRoute(to: view)
        }
}

private extension MapManager {
    func addRoute(to view: MKMapView) {
        if !view.overlays.isEmpty {
            view.removeOverlays(view.overlays)
        }
        
        let pin = MKPointAnnotation()
        pin.coordinate.longitude = placeLong
        pin.coordinate.latitude = placelat
        view.addAnnotation(pin)
        view.setRegion(MKCoordinateRegion(
            center: pin.coordinate, span: MKCoordinateSpan(
                                    latitudeDelta: 0.2,
                                    longitudeDelta: 0.2)
        ),
                          animated: true)
        

        guard let route = route else { return }
        let mapRect = route.boundingMapRect
        view.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
        view.addOverlay(route)
    }
}

class MapManagerDelegate: NSObject, MKMapViewDelegate {
    private func mapView(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locationss = \(locValue.latitude) \(locValue.longitude)")
        
        userLat = locValue.latitude
        userLong = locValue.longitude
        
        print("user lat \(userLat) user long \(userLong)")
      
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
         renderer.strokeColor = UIColor.blue
         renderer.lineWidth = 5.0

         return renderer
    }
}
