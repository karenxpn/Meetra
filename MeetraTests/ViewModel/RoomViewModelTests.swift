//
//  RoomViewModelTests.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 01.05.22.
//

import XCTest
@testable import Meetra

class RoomViewModelTests: XCTestCase {

    var service: MockChatService!
    var viewModel: ChatRoomViewModel!
    
    override func setUp() {
        self.service = MockChatService()
        self.viewModel = ChatRoomViewModel(dataManager: self.service)
    }
    
    func testGetChatIdWithError() {
        service.fetchChatIdError = true
        viewModel.getChatId(userID: 1)
        
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
        XCTAssertEqual(viewModel.chatId, 0)
    }
    
    func testGetChatIdWithSuccess() {
        service.fetchChatIdError = false
        viewModel.getChatId(userID: 1)
        
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertEqual(viewModel.chatId, 1)
    }
}
