//
//  ChatRoomViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.04.22.
//

import Foundation
import Combine

class ChatRoomViewModel: AlertViewModel, ObservableObject {
    
    @Published var chatId: Int = 0
    @Published var typing: Bool = false
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var online: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ChatServiceProtocol
    var socketManager: AppSocketManagerProtocol
    
    init(socketManager: AppSocketManagerProtocol = AppSocketManager.shared,
         dataManager: ChatServiceProtocol = ChatService.shared) {
        self.socketManager = socketManager
        self.dataManager = dataManager
        super.init()
    }
    
    func getChatId(userID: Int) {
        dataManager.fetchChatId(userId: userID)
            .sink { response in
                print(response)
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.chatId = response.value!.chat
                    self.joinRoom()
                    self.getTypingResponse()
                    self.getOnlineStatus(userID: userID)
                }
            }.store(in: &cancellableSet)
    }
    
    func getOnlineStatus(userID: Int) {
        socketManager.fetchOnlineUser { response in
            if response.userId == userID {
                self.online = response.online
            }
        }
    }
    
    func joinRoom() {
        socketManager.connectChatRoom(chatID: chatId)
    }
    
    func sendTyping() {
        socketManager.sendTyping(chatID: chatId, typing: typing)
    }
    
    func getTypingResponse() {
        socketManager.fetchTypingResponse { response in
            
        }
    }
}
