//
//  UserViewModelTests.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 29.03.22.
//

import XCTest
@testable import Meetra

class UserViewModelTests: XCTestCase {
    
    var service: MockUserService!
    var viewModel: UserViewModel!

    override func setUp() {
        self.service = MockUserService()
        self.viewModel = UserViewModel(dataManager: self.service)
    }
    
    func testGetUserWithError() {
        service.fetchUserError = true
        viewModel.getUser(userID: 1)
        
        XCTAssertNil(viewModel.user)
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)

    }
    
    func testGetUserWithSuccess() {
        service.fetchUserError = false
        viewModel.getUser(userID: 1)
        
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertNotNil(viewModel.user)
    }
    
    func testStarUserWithError() {
        service.starUserError = true
        service.fetchUserError = false
        viewModel.getUser(userID: 1)
        viewModel.starUser()
        XCTAssertEqual(viewModel.user!.starred, service.userModel.starred)
    }
    
    func testStarUserWithSuccess() {
        service.starUserError = false
        service.fetchUserError = false
        viewModel.getUser(userID: 1)
        
        viewModel.starUser()
        XCTAssertNotEqual(viewModel.user!.starred, service.userModel.starred)
    }
}
