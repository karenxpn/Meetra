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
    @AppStorage( "pending_files") private var localStorePendingFiles: Data = Data()
    
    
    @Published var typing: Bool = false
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var online: Bool = false
    @Published var messages = [MessageViewModel]()
    @Published var lastMessageID: Int = 0
    
    @Published var mediaBinaryData = Data(count: 0)
    @Published var signedURL: String = ""
    @Published var pendingMedia: MessageViewModel?
    
    // message
    @Published var message: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    private let userDefaults = UserDefaults.standard
    
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
    
    func getSignedURL(content_type: String) {
        dataManager.fetchSignedURL(key: Date().millisecondsSince1970, chatID: chatID,content_type: content_type)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.signedURL = response.value!.url
                    
                    // --------------- creating message locally -------------------
                    let message = response.value!.message
                    self.pendingMedia = MessageViewModel(message: message)
                    
                    // here should be the url from my local storage
                    self.dataManager.storeLocalFile(withData: self.mediaBinaryData, messageID: message.id, type: content_type) {
                        
                        // ------------------ get stored image for current message is ------------------
                        if let pendingURLs = try? JSONDecoder().decode([PendingFileModel].self, from: self.localStorePendingFiles) {
                            let mediaURL = pendingURLs.first(where: {$0.messageID == message.id})?.url
                            self.pendingMedia?.content = content_type == "video" ? (mediaURL?.absoluteString ?? "") : (mediaURL?.path ?? "")
                            
                            self.lastMessageID = message.id
                            self.messages.insert(self.pendingMedia!, at: 0)
                        }
                    }

                    /// upload to s3 using this signed url and as soon as the response is available
                    /// remove pending media message and insert new one( or just replace content with url )
                    
                }
            }.store(in: &cancellableSet)
    }
    
    func joinGetMessagesListenEventsOnInit() {
        getMessageList(messageID: 0)
        joinRoom()
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
        socketManager.connectChatRoom(chatID: chatID) {
            self.getTypingResponse()
            self.getOnlineStatus()
            self.getMessage()
        }
    }
    
    func sendTyping() {
        socketManager.sendTyping(chatID: chatID, typing: typing)
    }
    
    func getTypingResponse() {
        socketManager.fetchTypingResponse { response in
            
        }
    }
}
