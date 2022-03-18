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

class PlacesViewModel: ObservableObject {
    @AppStorage( "token" ) private var token: String = ""
    let socket: SocketIOClient


    var dataManage: PlacesServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(dataManage: PlacesServiceProtocol = PlacesService.shared) {
        self.dataManage = dataManage
        self.socket = AppSocketManager.shared.socket
        self.socket.removeAllHandlers()
        
        self.getLocationResponse()
    }

    
    func getLocationResponse() {
        dataManage.fetchLocationResponse(socket: socket) { _ in
            // do smth
        }
    }
    
    func sendLocation(lat: CGFloat, lng: CGFloat) {
        dataManage.sendLocation(socket: socket, lat: lat, lng: lng)
    }
}
