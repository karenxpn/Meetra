//
//  ChatRoomViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.04.22.
//

import Foundation
import Combine

class ChatRoomViewModel: AlertViewModel, ObservableObject {

    @Published var typing: Bool = false
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var online: Bool = false
    
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
        dataManager.fetchChatId(userId: userID)
            .sink { response in
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
    
    func joinGetMessagesListenEventsOnInit() {
        joinRoom()
        getTypingResponse()
        getOnlineStatus()
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
