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
        //        manager.allowsBackgroundLocationUpdates = true
        //        manager.showsBackgroundLocationIndicator = true
        manager.distanceFilter = 20
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if status == "true" {
            self.startUpdating()
        }
    }
    
    func startUpdating() {
        manager.startUpdatingLocation()
        self.monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: -38.720590091698284, longitude: -66.0070948168), identifier: "some_identifier")
    }
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
    
    func requestLocation() {
        initLocation()
        manager.requestAlwaysAuthorization()
        startUpdating()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        print(location)
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the devices supports region monitoring.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let region = CLCircularRegion(center: center,
                                          radius: 10, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            manager.startMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {            
            if UIApplication.shared.applicationState != .active {
                self.notification(body: "You left " + region.identifier)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let region = region as? CLCircularRegion {
            if UIApplication.shared.applicationState != .active {
                self.notification(body: "You entered" + region.identifier)
            }
        }
    }
    
    func notification(body: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = body
        notificationContent.sound = .default
        notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "location_change",
            content: notificationContent,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
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
            print("got response")
        }
    }
    
    func sendLocation() {
        print("sending location")
        if location != nil {
            socketManager.sendLocation(lat: self.location!.latitude, lng: self.location!.longitude)
        }
    }
    
    func sendOnline(online: Bool) {
        socketManager.sendOnlineUser(online: online)
    }
    
    func connectSocket(completion: @escaping(Any?) -> ()) {
        self.initLocation()
        if status == "true" {
            socketManager.connectSocket {
                self.getLocationResponse()
                self.sendLocation()
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}
