//
//  ChatViewModelTests.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 27.04.22.
//

import XCTest
@testable import Meetra

class ChatViewModelTests: XCTestCase {

    var service: MockChatService!
    var viewModel: ChatViewModel!
    
    override func setUp() {
        self.service = MockChatService()
        self.viewModel = ChatViewModel(dataManager: self.service)
    }
    
    func testGetChatScreenWithSuccess() {
        service.fetchChatsError = false
        service.fetchInterlocutorsError = false
        
        viewModel.getChatScreen()
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertFalse(viewModel.chats.isEmpty)
        XCTAssertFalse(viewModel.interlocutors.isEmpty)
    }
    
    func testGetChatScreenWithChatError() {
        service.fetchChatsError = true
        service.fetchInterlocutorsError = false
        
        viewModel.getChatScreen()
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
        XCTAssertTrue(viewModel.chats.isEmpty)
        XCTAssertFalse(viewModel.interlocutors.isEmpty)
    }
    
    func testGetChatScreenWithInterlocutorsError() {
        service.fetchChatsError = false
        service.fetchInterlocutorsError = true
        
        viewModel.getChatScreen()
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
        XCTAssertTrue(viewModel.interlocutors.isEmpty)
        XCTAssertFalse(viewModel.chats.isEmpty)
    }
    
    func testGetChatScreenWithBothError() {
        service.fetchChatsError = true
        service.fetchInterlocutorsError = true
        viewModel.getChatScreen()
        
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
        XCTAssertTrue(viewModel.chats.isEmpty)
        XCTAssertTrue(viewModel.interlocutors.isEmpty)
    }

    
    func testGetChatPageWithError() {
        service.fetchChatsError = true
        viewModel.getChatList()
        
        XCTAssertTrue(viewModel.chats.isEmpty)
    }
    
    func testGetChatPageWithSuccess() {
        service.fetchChatsError = false
        viewModel.getChatList()
        
        XCTAssertFalse(viewModel.chats.isEmpty)
    }
    
    func testGetInterlocutorsPageWithError() {
        service.fetchInterlocutorsError = true
        viewModel.getInterlocutors()
        
        XCTAssertTrue(viewModel.interlocutors.isEmpty)
    }
    
    func testGetInterlocutorsPageWithSuccess() {
        service.fetchInterlocutorsError = false
        viewModel.getInterlocutors()
        
        XCTAssertFalse(viewModel.interlocutors.isEmpty)
    }
    
    
}
