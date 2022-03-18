//
//  AppSocketManager.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.03.22.
//

import Foundation
import SocketIO
import SwiftUI

class AppSocketManager {
    static let shared = AppSocketManager()
    let manager: SocketManager
    let socket: SocketIOClient
    
    private init() {
        @AppStorage( "token" ) var token: String = ""
        
        manager = SocketManager(socketURL: URL(string: Credentials.socket_url)!, config: [.compress, .connectParams(["token" : token])])
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
        }
        
        socket.connect()
    }
}
