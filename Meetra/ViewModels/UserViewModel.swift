//
//  UserViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import Foundation
import SwiftUI
import Combine

class UserViewModel: AlertViewModel, ObservableObject {
    @AppStorage( "token" ) private var token: String = ""
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var page: Int = 1
    @Published var users = [UserPreviewModel]()
    @Published var requests = [FriendRequestModel]()
    
    @Published var reportReason: String = ""
    
    @Published var user: ModelUserViewModel? = nil
    @Published var friendRequestSentOffset: CGFloat = -UIScreen.main.bounds.height
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: UserServiceProtocol
    
    init( dataManager: UserServiceProtocol = UserService.shared) {
        self.dataManager = dataManager
    }
    
    func getUser(userID: Int) {
        loading = true
        dataManager.fetchUser(id: userID)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.user = ModelUserViewModel.init(user: response.value!)
                }
            }.store(in: &cancellableSet)
    }
    
    func sendFriendRequest(userID: Int) {
        dataManager.sendFriendRequest(id: userID)
            .sink { response in
                if response.error == nil {
                    self.friendRequestSentOffset = -UIScreen.main.bounds.height / 3
                }
            }.store(in: &cancellableSet)
    }
    
    func starUser() {
        dataManager.starUser(id: user!.id)
            .sink { response in
                if response.error == nil {
                    self.user!.starred.toggle()
                }
            }.store(in: &cancellableSet)
    }
    
    func starUserFromSwipes(userID: Int) {
        dataManager.starUser( id: userID)
            .sink { _ in
            }.store(in: &cancellableSet)
    }
    
    func removeUserFromStars(userID: Int) {
        dataManager.starUser(id: userID)
            .sink { response in
                if response.error == nil {
                    self.users.removeAll(where: {$0.id == userID})
                }
            }.store(in: &cancellableSet)
    }
    
    func getStarredUsers() {
        loading = true
        dataManager.fetchStarredUsers(page: page)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.users.append(contentsOf: response.value!.favourites)
                    self.page += 1
                }
            }.store(in: &cancellableSet)
    }
    
    func getFriendRequests() {
        loading = true
        dataManager.fetchFriendRequests(page: page)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.requests.append(contentsOf: response.value!.requests)
                    self.page += 1
                }
            }.store(in: &cancellableSet)
    }
    
    func accept_rejectFriendRequest( id: Int, status: String ) {
        let model = FriendRequestResponseRequest(id: id, status: status)
        
        dataManager.accept_rejectFriendRequest(model: model)
            .sink { response in
                if response.error == nil {
                    self.requests.removeAll(where: { $0.id == id })
                }
            }.store(in: &cancellableSet)
    }
    
    func reportUser( id: Int ) {
        dataManager.reportUser(id: id, reason: reportReason)
            .sink { _ in
            }.store(in: &cancellableSet)
    }
    
    func blockUser( id: Int ) {
        dataManager.blockUser(id: id)
            .sink { _ in
            }.store(in: &cancellableSet)
    }
}
