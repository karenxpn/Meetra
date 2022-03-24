//
//  AppSocketManager.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.03.22.
//

import Foundation
import SocketIO
import SwiftUI

protocol AppSocketManagerProtocol {
    func sendLocation( lat: CGFloat, lng: CGFloat)
    func fetchLocationResponse(completion: @escaping (Bool) -> ())
}

class AppSocketManager {
    static let shared: AppSocketManagerProtocol = AppSocketManager()
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

extension AppSocketManager: AppSocketManagerProtocol {
    
    func fetchLocationResponse(completion: @escaping (Bool) -> ()) {
        self.socket.off("location")
        self.socket.on("location") { (data, ack) in
            print(data)
            completion(false)
//            if let data = data[0] as? [String : Bool], let status = data["location"] {
//                DispatchQueue.main.async {
//                    completion(status)
//                }
//            }
        }
    }
    
    func sendLocation( lat: CGFloat, lng: CGFloat) {
        self.socket.emit("location", ["lat" : lat,
                                      "lng": lng])
    }
}
