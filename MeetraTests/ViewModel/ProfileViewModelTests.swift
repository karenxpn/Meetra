//
//  ProfileViewModelTests.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 06.04.22.
//

import XCTest
@testable import Meetra

class ProfileViewModelTests: XCTestCase {

    var service: MockProfileService!
    var viewModel: ProfileViewModel!
    
    override func setUp() {
        self.service = MockProfileService()
        self.viewModel = ProfileViewModel(dataManager: self.service)
    }
    
    func testGetProfileWithError() {
        service.fetchProfileError = true
        viewModel.getProfile()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetProfileWithSuccess() {
        service.fetchProfileError = false
        viewModel.getProfile()
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertNotNil(viewModel.profile)
    }
    
    func testGetUpdateFieldsWithImagesError() {
        service.fetchProfileImagesError = true
        service.fetchEditFieldsError = false
        
        viewModel.getProfileUpdateFields()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetUpdateFieldsWithFieldsError() {
        service.fetchProfileImagesError = false
        service.fetchEditFieldsError = true
        
        viewModel.getProfileUpdateFields()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetUpdateFieldsWithBothError() {
        service.fetchEditFieldsError = true
        service.fetchProfileImagesError = true
        
        viewModel.getProfileUpdateFields()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetUpdateFieldsWithSuccess() {
        service.fetchEditFieldsError = false
        service.fetchProfileImagesError = false
        viewModel.getProfileUpdateFields()
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }

}
