//
//  ChatRoomViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.04.22.
//

import Foundation
import Combine
import SwiftUI

class ChatRoomViewModel: AlertViewModel, ObservableObject {
    
    @Published var typing: Bool = false
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var online: Bool = false
    @Published var messages = [MessageViewModel]()
    @Published var lastMessageID: Int = 0
    
    
    // message
    @Published var message: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var chatID: Int
    var userID: Int
    var dataManager: ChatServiceProtocol
    var socketManager: AppSocketManagerProtocol
    
    init(socketManager: AppSocketManagerProtocol = AppSocketManager.shared,
         dataManager: ChatServiceProtocol = ChatService.shared,
         chatID: Int = 0,
         userID: Int = 0) {
        
        self.socketManager = socketManager
        self.dataManager = dataManager
        self.chatID = chatID
        self.userID = userID
        
        super.init()
        
        if chatID == 0 {
            getChatId()
        } else {
            joinGetMessagesListenEventsOnInit()
            // get chat messages
        }
    }
    
    deinit {
        print("deinit of room view model")
    }
    
    func getChatId() {
        loading = true
        dataManager.fetchChatId(userId: userID)
            .sink { response in
                self.loading = false
                print(response)
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.chatID = response.value!.chat
                    self.joinGetMessagesListenEventsOnInit()
                    // get chat messages
                }
            }.store(in: &cancellableSet)
    }
    
    func getMessageList(messageID: Int) {
        loading = true
        dataManager.fetchChatMessages(roomID: chatID, messageID: messageID)
            .sink { response in
                self.loading = false
                if response.error == nil {
                    let messages = response.value!.messages
                    self.messages.append(contentsOf: messages.reversed().map(MessageViewModel.init))
                    if !messages.isEmpty {
                        self.lastMessageID = self.messages[0].id
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    func joinGetMessagesListenEventsOnInit() {
        getMessageList(messageID: 0)
        joinRoom()
        getTypingResponse()
        getOnlineStatus()
        getMessage()
        // listen to message events
        // mark all messages as read
    }
    
    func sendTextMessage() {
        socketManager.sendMessage(chatID: chatID, type: "text", content: message) {
            // do smth
            self.message = ""
        }
    }
    
    func getMessage() {
        socketManager.fetchMessage(chatID: chatID) { message in
            self.lastMessageID = message.id
            withAnimation {
                self.messages.insert(MessageViewModel(message: message), at: 0)
            }
        }
    }
    
    func getOnlineStatus() {
        socketManager.fetchOnlineUser { response in
            if response.userId == self.userID {
                self.online = response.online
            }
        }
    }
    
    func joinRoom() {
        socketManager.connectChatRoom(chatID: chatID)
    }
    
    func sendTyping() {
        socketManager.sendTyping(chatID: chatID, typing: typing)
    }
    
    func getTypingResponse() {
        socketManager.fetchTypingResponse { response in
            
        }
    }
}
