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
        viewModel.chatID = 0
        viewModel.getChatId()
        
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
        XCTAssertEqual(viewModel.chatID, 0)
    }
    
    func testGetChatIdWithSuccess() {
        service.fetchChatIdError = false
        viewModel.chatID = 0
        viewModel.getChatId()
        
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertEqual(viewModel.chatID, 1)
    }
    
    func testGetMessgesListWithError() {
        service.fetchMessagesError = true
        viewModel.messages.removeAll()
        viewModel.getMessageList(messageID: 0)
        
        XCTAssertTrue(viewModel.messages.isEmpty)
    }
    
    func testGetMessagesWithSuccess() {
        service.fetchMessagesError = false
        viewModel.messages.removeAll()
        viewModel.getMessageList(messageID: 0)
        
        XCTAssertFalse(viewModel.messages.isEmpty)
    }
    
    func testGetNewConversationWithError() {
        service.fetchNewConversationError = true
        viewModel.getNewConversationResponse()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetNewConversationWithSuccess() {
        service.fetchNewConversationError = false
        viewModel.getNewConversationResponse()
        
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testGetSignedUrlWithError() {
        service.fetchSignedURLError = true
        viewModel.getSignedURL(content_type: "video")
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetSignedUrlWithSuccess() {
        service.fetchSignedURLError = false
        viewModel.getSignedURL(content_type: "video")
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertFalse(viewModel.signedURL.isEmpty)
    }
}
