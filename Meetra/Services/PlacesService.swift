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
    func joinEvent(socket: SocketIOClient, completion: @escaping () -> ())
    func sendLocation(socket: SocketIOClient, lat: CGFloat, lng: CGFloat)
    func fetchLocationResponse(socket: SocketIOClient, completion: @escaping (Bool) -> ())
}

class PlacesService {
    static let shared: PlacesServiceProtocol = PlacesService()
    
    private init() { }
}

extension PlacesService: PlacesServiceProtocol {
    func fetchLocationResponse(socket: SocketIOClient,completion: @escaping (Bool) -> ()) {
        socket.on("location") { (data, ack) in
            if let data = data[0] as? [String : Bool], let status = data["location"] {
                DispatchQueue.main.async {
                    completion(status)
                }
            }
        }
    }
    
    func sendLocation(socket: SocketIOClient, lat: CGFloat, lng: CGFloat) {
        socket.emit("sendLocation", ["lat" : lat,
                                     "lng": lng])
    }
    
    func joinEvent(socket: SocketIOClient, completion: @escaping () -> ()) {
        
        socket.emit("join" /* here should be some parameters */) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
