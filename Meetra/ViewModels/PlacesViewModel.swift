//
//  PlacesViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.03.22.
//

import Foundation
import SwiftUI
import Combine
import SocketIO

class PlacesViewModel: AlertViewModel, ObservableObject {
    @AppStorage( "token" ) private var token: String = ""
    @AppStorage( "ageLowerBound" ) var ageLowerBound: Int = 18
    @AppStorage( "ageUpperBound" ) var ageUppwerBound: Int = 51
    @AppStorage( "preferredGender" ) var preferredGender: String = "Всех"
    @AppStorage( "usersStatus" ) var usersStatus: String = "Всех"

    @Published var placeRoom: PlaceRoom? = nil
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var ageRange: ClosedRange<Int> = 18...51
    @Published var gender: String = ""
    @Published var status: String = ""
    
    @Published var loading: Bool = false
        
    var dataManager: PlacesServiceProtocol
    var socketManager: AppSocketManagerProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(dataManager: PlacesServiceProtocol = PlacesService.shared,
         socketManager: AppSocketManagerProtocol = AppSocketManager.shared) {
        self.dataManager = dataManager
        self.socketManager = socketManager
        super.init()
        
        self.ageRange = self.ageLowerBound...self.ageUppwerBound
        self.gender = self.preferredGender
        self.status = self.usersStatus
                
        self.getLocationResponse()
        self.getRoom()
    }

    
    func getLocationResponse() {
        
        socketManager.fetchLocationResponse { response in
            NotificationCenter.default.post(name: Notification.Name("location_lost"), object: nil, userInfo: ["info": response])

        }
    }
    
    func sendLocation(lat: CGFloat, lng: CGFloat) {
        socketManager.sendLocation(lat: lat, lng: lng)
    }
    
    func storeFilterValues() {
        var mark = false
        if ageLowerBound != ageRange.lowerBound ||
            ageUppwerBound != ageRange.upperBound ||
            preferredGender != gender ||
            usersStatus != status {
            mark = true
        }
        
        ageLowerBound = ageRange.lowerBound
        ageUppwerBound = ageRange.upperBound
        preferredGender = gender
        usersStatus = status
        
        if mark {
            getRoom()
        }
    }
    
    func getRoom() {
        loading = true
        let model = PlaceRoomRequest(minAge: ageLowerBound,
                                     maxAge: ageUppwerBound,
                                     gender: preferredGender,
                                     status: usersStatus)
        
        dataManager.fetchPlaceRoom(token: token, model: model)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.placeRoom = response.value!
                }
            }.store(in: &cancellableSet)
    }
}
