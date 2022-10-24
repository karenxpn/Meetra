//
//  LocationManager.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.03.22.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var navigate: Bool = false
    @Published var locationStatus: CLAuthorizationStatus?
    
    @Published var regions = [RegionModel]()
    @Published var regionState: CLRegionState?
        
    private var cancellableSet: Set<AnyCancellable> = []
    
    var socketManager: AppSocketManagerProtocol
    var locationManager: LocationServiceProtocol
    
    init(socketManager: AppSocketManagerProtocol = AppSocketManager.shared,
         locationManager: LocationServiceProtocol = LocationService.shared) {
        self.socketManager = socketManager
        self.locationManager = locationManager
        super.init()
    }
    
    convenience override init() {
        self.init(socketManager: AppSocketManager.shared,
                  locationManager: LocationService.shared)
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
        manager.distanceFilter = 30
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
        manager.requestAlwaysAuthorization()
        startUpdating()
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, radius: Double, identifier: String ) {
        // Make sure the devices supports region monitoring.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let region = CLCircularRegion(center: center,
                                          radius: radius,
                                          identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = true
            
            manager.startMonitoring(for: region)
        }
    }
    
    func stopMonitorRegion(region: RegionModel) {
        manager.stopMonitoring(for: CLCircularRegion(center: CLLocationCoordinate2D(latitude: region.lat,
                                                                                    longitude: region.lng),
                                                     radius: region.radius,
                                                     identifier: region.place_id))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if location == nil {
            location = locations.first?.coordinate
//            print(location)
            getRegions()
        } else if regionState == .outside {
            location = locations.first?.coordinate
//            print(location)
            getRegions()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        manager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        // check if the previous value of the region state is not the same -> send request
        if self.regionState != state {
            self.regionState = state
            print("Status for: \(region.identifier) is \(state.rawValue)")
            self.sendRegionState(region: region, state: state == .inside ? true : false)
            // send request here with region.identifier
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("entered region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("left region")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        navigate = true
    }
    
    func getRegions() {
        if let location {
            locationManager.fetchRegions(lat: location.latitude, lng: location.longitude)
                .sink { response in
                    if response.error == nil {
                        if let region = self.regions.first {
                            self.stopMonitorRegion(region: region)
                        }
                        
                        self.regions = response.value!.regions
                        let region = self.regions[0]
                        self.monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: region.lat,
                                                                                    longitude: region.lng),
                                                     radius: region.radius,
                                                     identifier: region.place_id)
                    }
                }.store(in: &cancellableSet)
        }
    }
    
    func sendRegionState(region: CLRegion, state: Bool) {
        self.locationManager.sendRegionState(identifier: region.identifier, state: state)
            .sink { _ in
            }.store(in: &cancellableSet)

    }
    
    func sendOnline(online: Bool) {
        socketManager.sendOnlineUser(online: online)
    }
}
