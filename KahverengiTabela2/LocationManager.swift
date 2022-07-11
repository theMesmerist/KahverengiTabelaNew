//
//  Functions.swift
//  KahverengiTabela2
//
//  Created by Emre Karaoğlu
//

import Foundation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    
    override init() {
           super.init()
        locationManager.delegate = self
           
           if CLLocationManager.locationServicesEnabled() {
               locationManager.requestWhenInUseAuthorization()
               // manager.requestAlwaysAuthorization()
               locationManager.startUpdatingLocation()
           }
       }
    
    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        let currentStatus = CLLocationManager.authorizationStatus()

        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }

        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
//                    uDefaults.setValue(true, forKey: "locationAccepted")
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
//            uDefaults.setValue(true, forKey: "locationAccepted")
        } else {
            self.locationManager.requestAlwaysAuthorization()
//            uDefaults.setValue(true, forKey: "locationAccepted")
        }
    }
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        userLat = locValue.latitude
        userLong = locValue.longitude
        
        print("user lat \(userLat) user long \(userLong)")
      
    }
}
