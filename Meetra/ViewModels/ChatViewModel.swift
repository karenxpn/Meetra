//
//  ChatViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import Foundation
import Combine
import SwiftUI

class ChatViewModel: AlertViewModel, ObservableObject {
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    
    @Published var chats = [ChatModelViewModel]()
    @Published var interlocutors = [InterlocutorsViewModel]()
    
    @Published var chatPage: Int = 1
    
    @Published var showSearchField: Bool = false
    @Published var search: String = ""
    
    @Published var loaded: Bool = false
    @Published var loadingPage: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ChatServiceProtocol
    var socketManager: AppSocketManagerProtocol
    
    init(dataManager: ChatServiceProtocol = ChatService.shared,
         socketManager: AppSocketManagerProtocol = AppSocketManager.shared) {
        self.dataManager = dataManager
        self.socketManager = socketManager
        super.init()
        
        $search
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { (text) in
                self.chatPage = 1
                self.chats.removeAll(keepingCapacity: false)
                
                if !text.isEmpty {
                    self.getChatList()
                } else {
                    self.getChatScreen()
                }
            }.store(in: &cancellableSet)
        
        getOnlineStatusChange()
    }
    
    
    func getChatScreen() {
        loading = true
        chatPage = 1
        Publishers.Zip(dataManager.fetchChatList(page: 1, query: ""), dataManager.fetchInterlocutors())
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
        dataManager.fetchChatList(page: chatPage, query: search)
            .sink { response in
                self.loadingPage = false
                if response.error == nil {
                    self.chats.append(contentsOf: response.value!.chats.map(ChatModelViewModel.init))
                    self.chatPage += 1
                }
            }.store(in: &cancellableSet)
    }
    
    func getOnlineStatusChange() {
        socketManager.fetchChatListOnlineUser { response in
            if let index = self.chats.firstIndex(where: {$0.chat.message.sender.id == response.userId}) {
                self.chats[index].online = response.online
            }
            
            if let index = self.interlocutors.firstIndex(where: {$0.id == response.userId}) {
                self.interlocutors[index].online = response.online
            }
        }
    }
    
    func getChatListChange() {
        socketManager.fetchChatListUpdates { response in
            if let index = self.chats.firstIndex(where: {$0.id == response.id }) {
                self.chats.remove(at: index)
            }
            
            withAnimation {
                self.chats.insert(ChatModelViewModel(chat: response), at: 0)
            }
        }
    }
    
    func getInterlocutorsChange() {
        socketManager.fetchInterlocutorsUpdates { response in
            if let index = self.interlocutors.firstIndex(where: {$0.id == response.id }) {
                self.interlocutors.remove(at: index)
            }
            
            withAnimation {
                self.interlocutors.insert(InterlocutorsViewModel(model: response), at: 0)
            }
        }
    }
}
