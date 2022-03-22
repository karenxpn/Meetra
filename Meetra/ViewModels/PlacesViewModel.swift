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
    @AppStorage( "preferredGender" ) var preferredGender: String = "Мужчина"
    @AppStorage( "usersStatus" ) var usersStatus: String = "Всех"

    @Published var placeRoom: PlaceRoom = PlaceRoom(users: [UserPreviewModel(id: 1, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 2, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 3, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 4, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 5, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 6, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 7, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 8, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 9, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 10, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 11, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 12, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 13, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 14, image: "Karen", name: "Karen", online: true),
                                                            UserPreviewModel(id: 15, image: "Karen", name: "Karen", online: true)], usersCount: 12, place: "EVN")
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var ageRange: ClosedRange<Int> = 18...61
    @Published var gender: String = ""
    @Published var status: String = ""
        
    let socket: SocketIOClient


    var dataManage: PlacesServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(dataManage: PlacesServiceProtocol = PlacesService.shared) {
        self.dataManage = dataManage
        self.socket = AppSocketManager.shared.socket
        self.socket.removeAllHandlers()
        super.init()
        
        self.ageRange = self.ageLowerBound...self.ageUppwerBound
        self.gender = self.preferredGender
        self.status = self.usersStatus
        
        self.getLocationResponse()
        self.getRoom()
    }

    
    func getLocationResponse() {
        dataManage.fetchLocationResponse(socket: socket) { _ in
            // do smth
        }
    }
    
    func sendLocation(lat: CGFloat, lng: CGFloat) {
        dataManage.sendLocation(socket: socket, lat: lat, lng: lng)
    }
    
    func getRoom() {
        dataManage.fetchPlaceRoom(token: token)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.placeRoom = response.value!
                }
            }.store(in: &cancellableSet)
    }
}
