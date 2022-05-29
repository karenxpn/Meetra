//
//  TabViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import Foundation
import SwiftUI
import Combine

class TabViewModel: ObservableObject {
    @AppStorage("userId") private var userID: Int = 0

    @Published var currentTab: Int = 0
    @Published var hasUnreadMessage: Bool = false
    
    var socketManager: AppSocketManagerProtocol
    
    init(socketManager: AppSocketManagerProtocol = AppSocketManager.shared) {
        self.socketManager = socketManager
        
        getUnreadMessageResponse()
    }
    
    func getUnreadMessageResponse() {
        socketManager.fetchTabViewUnreadMessage(userID: userID) { response in
            self.hasUnreadMessage = response
        }
    }
}
