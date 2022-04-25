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
    
    @Published var interlocutorsPage: Int = 1
    @Published var chatPage: Int = 1
    
    @Published var search: String = ""
    
    @Published var loaded: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ChatServiceProtocol

    init(dataManager: ChatServiceProtocol = ChatService.shared) {
        self.dataManager = dataManager
    }
    
    func getChatScreen() {
        loading = true
        Publishers.Zip(dataManager.fetchChatList(page: 1), dataManager.fetchInterlocutors(page: 1))
            .sink { chats, interlocutors in
                self.loading = false
                self.loaded = true
                if chats.error != nil || interlocutors.error != nil {
                    self.makeAlert(with: chats.error == nil ? interlocutors.error! : chats.error!,
                                   message: &self.alertMessage,
                                   alert: &self.showAlert)
                } else {
                    self.chats = chats.value!.chats.map(ChatModelViewModel.init)
                    self.interlocutors = interlocutors.value!.interlocutors.map(InterlocutorsViewModel.init)
                    
                    self.interlocutorsPage += 1
                    self.chatPage += 1
                }
            }.store(in: &cancellableSet)
    }
    
    func getChatList() {
        dataManager.fetchChatList(page: chatPage)
            .sink { response in
                if response.error == nil {
                    self.chats.append(contentsOf: response.value!.chats.map(ChatModelViewModel.init))
                }
            }.store(in: &cancellableSet)
    }
    
    func getInterlocutors() {
        dataManager.fetchInterlocutors(page: interlocutorsPage)
            .sink { response in
                if response.error == nil {
                    self.interlocutors.append(contentsOf: response.value!.interlocutors.map(InterlocutorsViewModel.init))
                }
            }.store(in: &cancellableSet)
    }
    
    
}
