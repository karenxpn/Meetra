//
//  LocationManager.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.03.22.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var navigate: Bool = false
    @Published var locationStatus: CLAuthorizationStatus?


    override init() {
        super.init()
    }
    
    var status: Bool {
        if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
            return true
        } else {
            return false
        }
    }
    
    func initLocation() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        initLocation()
        manager.requestWhenInUseAuthorization()
        startUpdating()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        navigate = true
    }
}
