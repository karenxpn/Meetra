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
    
    @Published var users = [SwipeUserViewModel]()
    @Published var swipePage: Int = 1
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var ageRange: ClosedRange<Int> = 18...51
    @Published var gender: String = ""
    @Published var status: String = ""
    
    @Published var loading: Bool = false
    
    var dataManager: PlacesServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(dataManager: PlacesServiceProtocol = PlacesService.shared) {
        self.dataManager = dataManager
        super.init()
        
        self.ageRange = self.ageLowerBound...self.ageUppwerBound
        self.gender = self.preferredGender
        self.status = self.usersStatus
    }
    
    func storeFilterValues(location: String) {
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
            if location == "place" {
                getRoom()
            } else {
                swipePage = 1
                self.users.removeAll(keepingCapacity: false)
                getSwipes()
            }
        }
    }
    
    func getRoom() {
        loading = true
        let model = PlaceRoomRequest(minAge: ageLowerBound,
                                     maxAge: ageUppwerBound,
                                     gender: preferredGender,
                                     status: usersStatus)
        
        dataManager.fetchPlaceRoom(model: model)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.placeRoom = response.value!
                }
            }.store(in: &cancellableSet)
    }
    
    func getSwipes() {
        loading = true
        let model = PlaceRoomRequest(minAge: ageLowerBound,
                                     maxAge: ageUppwerBound,
                                     gender: preferredGender,
                                     status: usersStatus)
        
        dataManager.fetchSwipes(page: swipePage,
                                model: model)
        .sink { response in
            self.loading = false
            if response.error != nil {
                self.users.removeAll(keepingCapacity: false)
                self.makeAlert(with: response.error!,
                               message: &self.alertMessage,
                               alert: &self.showAlert)
            } else {
                self.users = response.value!.users.map{ SwipeUserViewModel(user: $0 )}
            }
        }.store(in: &cancellableSet)
    }
}
