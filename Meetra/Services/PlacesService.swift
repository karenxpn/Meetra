//
//  PlacesService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.03.22.
//

import Foundation
import Alamofire
import SocketIO
import Combine

protocol PlacesServiceProtocol {
    func connect_and_join_socket(socket: SocketIOClient, token: String, completion: @escaping () -> ())
    func sendLocation(socket: SocketIOClient, token: String, lat: CGFloat, lng: CGFloat)
    func fetchLocationResponse(socket: SocketIOClient, token: String, completion: @escaping (Bool) -> ())
}

class PlacesService {
    static let shared: PlacesServiceProtocol = PlacesService()
    
    private init() { }
}

extension PlacesService: PlacesServiceProtocol {
    func fetchLocationResponse(socket: SocketIOClient, token: String, completion: @escaping (Bool) -> ()) {
        socket.on("location") { (data, ack) in
            if let data = data[0] as? [String : Bool], let status = data["typing"] {
                DispatchQueue.main.async {
                    completion(status)
                }
            }
        }
    }
    
    func sendLocation(socket: SocketIOClient, token: String, lat: CGFloat, lng: CGFloat) {
        socket.emit("sendLocation", ["lat" : lat,
                                     "lng": lng])
    }
    
    func connect_and_join_socket(socket: SocketIOClient, token: String, completion: @escaping () -> ()) {
        let socketConnectionStatus = socket.status
        
        if socketConnectionStatus == SocketIOStatus.connected {
            socket.emit("join", ["token" : token]) {
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else {
            socket.on(clientEvent: .connect) { (data, ack) in
                socket.emit("join", ["token" : token]) {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
            
            socket.connect()
        }
    }
}
