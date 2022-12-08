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
    @Published var swipePage: Int = 0
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var ageRange: ClosedRange<Int> = 18...51
    @Published var gender: String = ""
    @Published var status: String = ""
    
    @Published var loading: Bool = false
    @Published var placeUsers = [[UserPreviewModel]]()
    @Published var loadingRoomPage: Bool = false
    
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
                self.placeRoom = nil
                self.placeUsers.removeAll()
                getRoom()
            } else {
                swipePage = 0
                self.users.removeAll(keepingCapacity: false)
                getSwipes()
            }
        }
    }

    
    func getRoom() {
        if placeRoom == nil {
            loading = true
        } else {
            loadingRoomPage = true
        }
        var skip = self.placeRoom?.users.count ?? 0
        let model = PlaceRoomRequest(minAge: ageLowerBound,
                                     maxAge: ageUppwerBound,
                                     gender: preferredGender,
                                     status: usersStatus,
                                     skip: skip > 0 ? skip - 2 : 0,
                                     take: 10)
        
        dataManager.fetchPlaceRoom(model: model)
            .sink { response in
                self.loading = false
                self.loadingRoomPage = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    if self.placeRoom == nil {
                        self.placeRoom = response.value!
                        if !(self.placeRoom?.users.isEmpty ?? false) {
                            // insert group chat and location icons
                            self.placeRoom?.users.insert(UserPreviewModel(id: 0, image: "", name: "Общий чат", age: 0, online: false), at: 0)
                            self.placeRoom?.users.insert(UserPreviewModel(id: 0, image: "", name: "Локация", age: 0, online: false), at: 2)
                            self.placeUsers = self.placeRoom?.users.createGrid(size: 3) ?? [[]]
                        }
                    } else {
                        self.placeRoom?.users.append(contentsOf: response.value!.users)
                        self.placeUsers = self.placeRoom?.users.createGrid(size: 3) ?? [[]]
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    func getSwipes() {
        loading = true
        let model = PlaceRoomRequest(minAge: ageLowerBound,
                                     maxAge: ageUppwerBound,
                                     gender: preferredGender,
                                     status: usersStatus,
                                     skip: swipePage * 10,
                                     take: 10)
        
        dataManager.fetchSwipes(model: model)
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
