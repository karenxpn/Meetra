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
    
    func testGetStarredUsersWithError() {
        service.fetchStarredUsersError = true
        viewModel.getStarredUsers()
        
        XCTAssertTrue(viewModel.users.isEmpty)
    }
    
    func testGetStarredUsersWithSuccess() {
        service.fetchStarredUsersError = false
        viewModel.getStarredUsers()
        
        XCTAssertFalse(viewModel.users.isEmpty)
    }
    
    func testGetFriendRequestsWithError() {
        service.fetchFriendRequestsError = true
        viewModel.getFriendRequests()
        
        XCTAssertTrue(viewModel.requests.isEmpty)
    }
    
    func testGetFriendRequestsWithSuccess() {
        service.fetchFriendRequestsError = false
        viewModel.getFriendRequests()
        
        XCTAssertFalse(viewModel.requests.isEmpty)
    }
    
    func testAcceptOrRejectFriendRequestWithError() {
        service.fetchFriendRequestsError = false
        service.accept_rejectError = true
        viewModel.getFriendRequests()
        
        viewModel.accept_rejectFriendRequest(id: 1, status: "reject")
        XCTAssertTrue(viewModel.requests.contains(where: {$0.id == 1}))
    }
    
    func testAcceptOrRejectFriendRequestWithSuccess() {
        service.fetchFriendRequestsError = false
        service.accept_rejectError = false
        viewModel.getFriendRequests()
        
        viewModel.accept_rejectFriendRequest(id: 1, status: "reject")
        XCTAssertFalse(viewModel.requests.contains(where: {$0.id == 1}))
    }
}
