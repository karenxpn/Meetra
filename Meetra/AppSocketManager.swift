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
    
    func sendTyping(chatID: Int, typing: Bool)
    func fetchTypingResponse(completion: @escaping (TypingResponse) -> ())
    
    func sendOnlineUser(online: Bool)
    func fetchOnlineUser(completion: @escaping (OnlineResponseModel) -> ())
    func fetchChatListOnlineUser(completion: @escaping (OnlineResponseModel) -> ())
    func fetchChatListUpdates(userID: Int, completion: @escaping (ChatModel) -> ())
    func fetchInterlocutorsUpdates(userID: Int, completion: @escaping (InterlocutorsModel) -> ())
    
    func connectChatRoom(chatID: Int, completion: @escaping() -> ())
    func sendMessage(chatID: Int, type: String, content: String, repliedTo: Int?, completion: @escaping() -> ())
    func fetchMessage(chatID: Int, completion: @escaping(MessageModel) -> ())
    
    func fetchTabViewUnreadMessage(userID: Int, completion: @escaping (Bool) -> ())
    func sendMedia(chatID: Int, messageID: Int, status: String)
    
    func editMessage(chatID: Int, messageID: Int, message: String, completion: @escaping() -> ())
    func fetchEditMessageResponse(chatID: Int, completion: @escaping (MessageModel) -> ())
    
    func deleteMessage(chatID: Int, messageID: Int, completion: @escaping() -> ())
    func fetchDeleteMessageResponse(chatID: Int, completion: @escaping(Int) -> ())
    
    func sendReaction(messageID: Int, reaction: String, completion: @escaping() -> ())
    func fetchReaction(completion: @escaping(ReactionModel) -> ())
    
    func sendRead(messageID: Int, completion: @escaping() -> ())
    func fetchRead(completion: @escaping(ReadModel) -> ())
    
    func disconnectSocket()
    func connectSocket(completion: @escaping() -> ())
    
    func fetchNotification(userID: Int, completion: @escaping(PushNotificationModel) -> ())
}

class AppSocketManager {
    static let shared: AppSocketManagerProtocol = AppSocketManager()
    var manager: SocketManager?
    var socket: SocketIOClient?
    
    private init() {
        connectSocket() { }
    }
}

extension AppSocketManager: AppSocketManagerProtocol {
    func fetchNotification(userID: Int, completion: @escaping (PushNotificationModel) -> ()) {
        self.socket?.off("notification-\(userID)")
        listenEvent(event: "notification-\(userID)", response: PushNotificationModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    func sendRead(messageID: Int, completion: @escaping () -> ()) {
        self.socket?.emit("read-message", ["messageId": messageID])
    }
    
    func fetchRead(completion: @escaping (ReadModel) -> ()) {
        self.socket?.off("read-message")
        listenEvent(event: "read-message", response: ReadModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    func sendReaction(messageID: Int, reaction: String, completion: @escaping () -> ()) {
        self.socket?.emit("react-message", ["messageId": messageID,
                                            "reaction" : reaction])
    }
    
    func fetchReaction(completion: @escaping (ReactionModel) -> ()) {
        self.socket?.off("react-message")
        listenEvent(event: "react-message", response: ReactionModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
        
    }
    
    
    func sendMedia(chatID: Int, messageID: Int, status: String) {
        self.socket?.emit("media", ["chatId" : chatID,
                                    "messageID": messageID,
                                    "status" : status])
    }
    
    func fetchTabViewUnreadMessage(userID: Int, completion: @escaping (Bool) -> ()) {
        self.socket?.off("tab-unread-message-\(userID)")
        self.socket?.on("tab-unread-message-\(userID)") { (data, ack) in
            if let data = data[0] as? [String : Bool], let status = data["unreadMessage"] {
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
    
    
    func sendMessage(chatID: Int, type: String, content: String, repliedTo: Int?, completion: @escaping () -> ()) {
        self.socket?.emit("send-message", ["chatId" : chatID,
                                           "type" : type,
                                           "message" : content,
                                           "repliedTo": repliedTo], completion: {
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
    func fetchMessage(chatID: Int, completion: @escaping (MessageModel) -> ()) {
        self.socket?.off("send-message")
        listenEvent(event: "send-message", response: MessageModel.self) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    func deleteMessage(chatID: Int, messageID: Int, completion: @escaping() -> ()) {
        self.socket?.emit("delete-message", ["chatId" : chatID,
                                             "messageId": messageID], completion: {
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
    func fetchDeleteMessageResponse(chatID: Int, completion: @escaping(Int) -> ()) {
        self.socket?.off("delete-message")
        self.socket?.on("delete-message"){ (data, ack) in
            if let data = data[0] as? [String : Int], let id = data["inside"] {
                DispatchQueue.main.async {
                    completion(id)
                }
            }
        }
    }
    
    func editMessage(chatID: Int, messageID: Int, message: String, completion: @escaping() -> ()) {
        self.socket?.emit("edit-message", ["chatId" : chatID,
                                           "messageId": messageID,
                                           "message": message], completion: {
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
    func fetchEditMessageResponse(chatID: Int, completion: @escaping (MessageModel) -> ()) {
        self.socket?.off("edit-message")
        listenEvent(event: "edit-message", response: MessageModel.self) { response in
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
    
    func sendOnlineUser(online: Bool) {
        self.socket?.emit("online", ["online" : online])
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
        if self.socket?.status == .connected {
            self.socket?.emit("join-chat", ["chatId" : chatID]) {
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else {
            self.socket?.on(clientEvent: .connect, callback: { data, ack in
                self.socket?.emit("join-chat", ["chatId" : chatID]) {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            })
            
            self.socket?.connect()
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
        socket?.removeAllHandlers()
    }
    
    func connectSocket(completion: @escaping() -> ()) {
        @AppStorage( "token" ) var token: String = ""
        @AppStorage( "initialToken" ) var initialToken: String = ""
        
        if !token.isEmpty {
            manager = SocketManager(socketURL: URL(string: Credentials.socket_url)!,
                                    config: [.compress,
                                             .connectParams(["token" : token])])
            
            socket = manager?.defaultSocket
            socket?.on(clientEvent: .connect) {data, ack in
                DispatchQueue.main.async {
                    completion()
                }
                print("socket connected")
            }
            
            socket?.connect()
        }
    }
    
    func listenEvent<T> (event: String, response: T.Type, completion: @escaping(T) -> () ) where T : Codable {
        self.socket?.on(event) { (data, ack) in
            
            print("event listening: \(event)")
            print(data)
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
                print("error", error.localizedDescription)
            }
        }
    }
}
