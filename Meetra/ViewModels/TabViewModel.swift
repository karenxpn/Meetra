//
//  TabViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import Foundation
import Combine

class TabViewModel: ObservableObject {
    @Published var currentTab: Int = 0
    @Published var hasUnreadMessage: Bool = true
    
    var socketManager: AppSocketManagerProtocol
    
    init(socketManager: AppSocketManagerProtocol = AppSocketManager.shared) {
        self.socketManager = socketManager
        
        getUnreadMessageResponse()
    }
    
    func getUnreadMessageResponse() {
        socketManager.fetchTabViewUnreadMessage { response in
            self.hasUnreadMessage = response
        }
    }

}
