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
                                                            UserPreviewModel(id: 11, image: "Karen", name: "Karen", online: true)], usersCount: 12, place: "EVN")
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let socket: SocketIOClient


    var dataManage: PlacesServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(dataManage: PlacesServiceProtocol = PlacesService.shared) {
        self.dataManage = dataManage
        self.socket = AppSocketManager.shared.socket
        self.socket.removeAllHandlers()
        super.init()
        
        self.getLocationResponse()
//        self.getRoom()
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
