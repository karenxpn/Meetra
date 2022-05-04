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
    func fetchChatListOnlineUser(completion: @escaping (OnlineResponseModel) -> ())
    func fetchChatListUpdates(userID: Int, completion: @escaping (ChatModel) -> ())
    func fetchInterlocutorsUpdates(userID: Int, completion: @escaping (InterlocutorsModel) -> ())
    
    func connectChatRoom(chatID: Int, completion: @escaping() -> ())
    func sendMessage(chatID: Int, type: String, content: String, completion: @escaping() -> ())
    func fetchMessage(chatID: Int, completion: @escaping(MessageModel) -> ())
    
    func fetchTabViewUnreadMessage(completion: @escaping (Bool) -> ())
    
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
    func fetchTabViewUnreadMessage(completion: @escaping (Bool) -> ()) {
        self.socket?.off("tab-unread-message")
        self.socket?.on("tab-unread-message") { (data, ack) in
            if let data = data[0] as? [String : Bool], let status = data["unread-message"] {
                DispatchQueue.main.async {
                    completion(status)
                }
            }
        }
    }
    
    func fetchChatListUpdates(userID: Int, completion: @escaping (ChatModel) -> ()) {
        self.socket?.off("chat-list-\(userID)")
        listenEvent(event: "chat-list-\(userID)", response: ChatModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    func fetchInterlocutorsUpdates(userID: Int, completion: @escaping (InterlocutorsModel) -> ()) {
        self.socket?.off("interlocutos-list-\(userID)")
        listenEvent(event: "interlocutos-list-\(userID)", response: InterlocutorsModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    
    func sendMessage(chatID: Int, type: String, content: String, completion: @escaping () -> ()) {
        self.socket?.emit("message", ["chatId" : chatID,
                                      "type" : type,
                                      "message" : content], completion: {
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
    func fetchMessage(chatID: Int, completion: @escaping (MessageModel) -> ()) {
        self.socket?.off("message")
        listenEvent(event: "message", response: MessageModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    func fetchChatListOnlineUser(completion: @escaping (OnlineResponseModel) -> ()) {
        self.socket?.off("chat-list-online")
        listenEvent(event: "chat-list-online", response: OnlineResponseModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    func fetchOnlineUser(completion: @escaping (OnlineResponseModel) -> ()) {
        self.socket?.off("online")
        listenEvent(event: "online", response: OnlineResponseModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    
    func connectChatRoom(chatID: Int, completion: @escaping() -> ()) {
        self.socket?.emit("join-chat", ["chatId" : chatID]) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func sendTyping(chatID: Int, typing: Bool) {
        self.socket?.emit("typing", ["chatId" : chatID,
                                     "typing": typing])
    }
    
    func fetchTypingResponse(completion: @escaping (TypingResponse) -> ()) {
        self.socket?.off("typing")
        
        self.listenEvent(event: "typing", response: TypingResponse.self) { response in
            DispatchQueue.main.async {
                completion(response)
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
    
    func listenEvent<T> (event: String, response: T.Type, completion: @escaping(T) -> () ) where T : Codable {
        self.socket?.on(event) { (data, ack) in
            
            print("event listening")
            do {
                if !data.isEmpty {
                    let data = data[0]
                    let serialized = try JSONSerialization.data(withJSONObject: data)
                    let decoded = try JSONDecoder().decode(T.self, from: serialized)
                    
                    print(decoded)
                    
                    DispatchQueue.main.async {
                        completion(decoded)
                    }
                }
            } catch {
                print("error")
            }
        }
    }
}
