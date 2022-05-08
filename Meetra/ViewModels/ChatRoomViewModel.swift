//
//  ChatRoomViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.04.22.
//

import Foundation
import Combine
import SwiftUI
import AVFAudio

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
    
    @Published var newConversation: Bool = false
    @Published var newConversationResponse: NewConversationResponse?
    
    // message
    @Published var message: String = ""
    
    
    // audio message
    
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
                    } else if messageID == 0 && messages.isEmpty {
                        self.newConversation = true
                        self.getNewConversationResponse()
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    func getSignedURL(content_type: String) {
        dataManager.fetchSignedURL(key: Date().millisecondsSince1970, chatID: chatID,content_type: content_type)
            .sink { response in
                
                // hide audio preview if the content type is audio
                if content_type == "audio" {
                    NotificationCenter.default.post(name: Notification.Name("hide_audio_preview"), object: nil)
                }
                
                
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.signedURL = response.value!.url
                    
                    // --------------- creating message locally -------------------
                    let message = response.value!.message
                    let urlForMedia = response.value!.message.message
                    self.pendingMedia = MessageViewModel(message: message)
                    
                    self.storeMediaFile(content_type: content_type, messageID: message.id, serverMediaURL: urlForMedia)
                }
            }.store(in: &cancellableSet)
    }
    
    func storeMediaFile(content_type: String, messageID: Int, serverMediaURL: String) {
        // here should be the url from my local storage
        self.dataManager.storeLocalFile(withData: self.mediaBinaryData, messageID: messageID, type: content_type) { pendingURLs in
            
            // ------------------ get stored image for current message id ------------------
            let mediaURL = pendingURLs.first(where: {$0.messageID == messageID})?.url
            self.pendingMedia?.content = content_type == "photo" ? (mediaURL?.path ?? "") : (mediaURL?.absoluteString ?? "")
            
            // insert message to the front of array
            self.lastMessageID = messageID
            self.messages.insert(self.pendingMedia!, at: 0)
            self.newConversation = false
                        
            // store file to server and on completion update message
            self.dataManager.storeFileToServer(file: self.mediaBinaryData, url: self.signedURL, completion: { completion in
                if completion {
                    self.messages[0].content = serverMediaURL
                    self.messages[0].status = "sent"
                    self.dataManager.removeLocalFile(url: mediaURL!, messageID: messageID) { }
                } else {
                    print("failed to upload file to server")
                    // show smth like failted to send file
                }
            })
        }
    }
    
    func getNewConversationResponse() {
        loading = true
        dataManager.fetchNewConversationResponse(roomID: chatID)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.newConversationResponse = response.value!
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
            self.newConversation = false
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
