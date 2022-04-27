//
//  ChatViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import Foundation
import Combine

class ChatViewModel: AlertViewModel, ObservableObject {
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    
    @Published var chats = [ChatModelViewModel]()
    @Published var interlocutors = [InterlocutorsViewModel]()
    
    @Published var chatPage: Int = 1
    
    @Published var search: String = ""
    
    @Published var loaded: Bool = false
    @Published var loadingPage: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ChatServiceProtocol

    init(dataManager: ChatServiceProtocol = ChatService.shared) {
        self.dataManager = dataManager
        super.init()
        
        getChatScreen()
    }
    
    
    func getChatScreen() {
        loading = true
        Publishers.Zip(dataManager.fetchChatList(page: 1), dataManager.fetchInterlocutors())
            .sink { chats, interlocutors in
                self.loading = false
                self.loaded = true
                
                if chats.error != nil || interlocutors.error != nil {
                    self.makeAlert(with: chats.error == nil ? interlocutors.error! : chats.error!,
                                   message: &self.alertMessage,
                                   alert: &self.showAlert)
                }
                
                if chats.error == nil {
                    self.chats = chats.value!.chats.map(ChatModelViewModel.init)
                    self.chatPage = 2
                    self.getChatList()
                }
                
                if interlocutors.error == nil {
                    self.interlocutors = interlocutors.value!.interlocutors.map(InterlocutorsViewModel.init)
                }
            }.store(in: &cancellableSet)
    }
    
    func getChatList() {
        loadingPage = true
        dataManager.fetchChatList(page: chatPage)
            .sink { response in
                self.loadingPage = false
                if response.error == nil {
                    self.chats.append(contentsOf: response.value!.chats.map(ChatModelViewModel.init))
                    self.chatPage += 1
                }
            }.store(in: &cancellableSet)
    }
}
