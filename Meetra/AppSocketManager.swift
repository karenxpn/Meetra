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
    
    func sendTyping(chatID: Int, typing: Bool)
    func fetchTypingResponse(completion: @escaping (TypingResponse) -> ())
    
    func fetchOnlineUser(completion: @escaping (OnlineResponseModel) -> ())
    
    func connectChatRoom(chatID: Int)
    
    func disconnectSocket()
    func connectSocket()
}

class AppSocketManager {
    static let shared: AppSocketManagerProtocol = AppSocketManager()
    var manager: SocketManager?
    var socket: SocketIOClient?
    
    private init() {
        connectSocket()
    }
}

extension AppSocketManager: AppSocketManagerProtocol {
    func fetchOnlineUser(completion: @escaping (OnlineResponseModel) -> ()) {
        self.socket?.off("online")
        self.socket?.on("online") { (data, ack) in
            
            do {
                if !data.isEmpty {
                    let data = data[0]
                    let serialized = try JSONSerialization.data(withJSONObject: data)
                    let online = try JSONDecoder().decode(OnlineResponseModel.self, from: serialized)
                    
                    print(online)
                    
                    DispatchQueue.main.async {
                        completion(online)
                    }
                }
            } catch {
                print("error")
            }
        }
    }
    
    
    func connectChatRoom(chatID: Int) {
        self.socket?.emit("join-chat", ["chatId" : chatID])
    }
    
    func sendTyping(chatID: Int, typing: Bool) {
        self.socket?.emit("typing", ["chatId" : chatID,
                                     "typing": typing])
    }
    
    func fetchTypingResponse(completion: @escaping (TypingResponse) -> ()) {
        self.socket?.off("typing")
        self.socket?.on("typing") { (data, ack) in
            
            do {
                if !data.isEmpty {
                    let data = data[0]
                    let serialized = try JSONSerialization.data(withJSONObject: data)
                    let typing = try JSONDecoder().decode(TypingResponse.self, from: serialized)
                    
                    DispatchQueue.main.async {
                        completion(typing)
                    }
                }
            } catch {
                print("error")
            }
        }
    }
    
    
    func disconnectSocket() {
        socket?.disconnect()
    }
    
    func connectSocket() {
        @AppStorage( "token" ) var token: String = ""
        @AppStorage( "initialToken" ) var initialToken: String = ""
        
        if !token.isEmpty {
            manager = SocketManager(socketURL: URL(string: Credentials.socket_url)!,
                                    config: [.compress,
                                             .connectParams(["token" : token])])
            
            socket = manager?.defaultSocket
            socket?.on(clientEvent: .connect) {data, ack in
                print("socket connected")
            }
            
            socket?.connect()
        }
    }
    
    func fetchLocationResponse(completion: @escaping (Bool) -> ()) {
        self.socket?.off("location")
        self.socket?.on("location") { (data, ack) in
            if let data = data[0] as? [String : Bool], let status = data["inside"] {
                DispatchQueue.main.async {
                    completion(status)
                }
            }
        }
    }
    
    func sendLocation( lat: CGFloat, lng: CGFloat) {
        self.socket?.emit("location", ["lat" : lat,
                                       "lng": lng])
    }
}
