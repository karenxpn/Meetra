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
    
    @Published var user: ModelUserViewModel? = nil
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: UserServiceProtocol
    
    init( dataManager: UserServiceProtocol = UserService.shared) {
        self.dataManager = dataManager
    }
    
    func getUser(userID: Int) {
        loading = true
        dataManager.fetchUser(token: token, id: userID)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.user = ModelUserViewModel.init(user: response.value!)
                }
            }.store(in: &cancellableSet)
    }
    
    func sendFriendRequest() {
        dataManager.sendFriendRequest(token: token, id: user!.id)
            .sink { response in
                if response.error == nil {
                    // do smth
                }
            }.store(in: &cancellableSet)
    }
    
    func starUser() {
        dataManager.starUser(token: token, id: user!.id, starred: !user!.starred)
            .sink { response in
                if response.error == nil {
                    self.user!.starred.toggle()
                }
            }.store(in: &cancellableSet)
    }
}
