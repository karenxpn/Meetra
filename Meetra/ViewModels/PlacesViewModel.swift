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
    let manager = SocketManager(socketURL: URL(string: Credentials.socket_url)!, config: [.compress])
    let socket: SocketIOClient


    var dataManage: PlacesServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(dataManage: PlacesServiceProtocol = PlacesService.shared) {
        self.dataManage = dataManage
        self.socket = manager.defaultSocket
        self.joinSocket()
        print("init")
    }
    
    func joinSocket() {
        dataManage.connectAndJoinSocket(socket: socket, token: token) {
            // place functions of response
            self.getLocationResponse()
        }
    }
    
    func getLocationResponse() {
        dataManage.fetchLocationResponse(socket: socket, token: token) { _ in
            // do smth
        }
    }
    
    func sendLocation(lat: CGFloat, lng: CGFloat) {
        dataManage.sendLocation(socket: socket, token: token, lat: lat, lng: lng)
    }
    
    
    func removeSocket() {
        socket.removeAllHandlers()
    }
}
