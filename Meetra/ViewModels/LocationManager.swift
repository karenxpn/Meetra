//
//  LocationManager.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.03.22.
//

import Foundation
import CoreLocation
import SwiftUI


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var navigate: Bool = false
    @Published var locationStatus: CLAuthorizationStatus?
    
    @Published var lost_location_socket: Bool = false
    
    var socketManager: AppSocketManagerProtocol
    
    init(socketManager: AppSocketManagerProtocol = AppSocketManager.shared) {
        self.socketManager = socketManager
        super.init()
    }
    
    convenience override init() {
        self.init(socketManager: AppSocketManager.shared)
    }
    
    var status: String {
        if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
            return "true"
        } else if locationStatus == .notDetermined {
            return "request"
        } else {
            return "settings"
        }
    }
    
    func initLocation() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if status == "true" {
            self.startUpdating()
        }
    }
    
    func startUpdating() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
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
    
    func getLocationResponse() {
        socketManager.fetchLocationResponse { response in
            self.lost_location_socket = !response
        }
    }
    
    func sendLocation() {
        if location != nil {
            socketManager.sendLocation(lat: self.location!.latitude, lng: self.location!.longitude)
        }
    }
    
    func connectSocket(completion: @escaping() -> ()) {
        self.initLocation()
        if status == "true" {
            socketManager.connectSocket {
                self.getLocationResponse()
                self.sendLocation()
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
