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
    
    func testDeleteProfileImageWithError() {
        // get profile all fields
        service.fetchEditFieldsError = false
        service.fetchProfileImagesError = false
        viewModel.getProfileUpdateFields()
        
        
        service.deleteProfileImageError = true
        viewModel.deleteProfileImage(id: 1)
        
        XCTAssertTrue(viewModel.profileImages.contains(where: {$0.id == 1 }))
    }
    
    func testDeleteProfileImageWithSuccess() {
        
        service.fetchEditFieldsError = false
        service.fetchProfileImagesError = false
        viewModel.getProfileUpdateFields()
        
        
        service.deleteProfileImageError = false
        viewModel.deleteProfileImage(id: 1)
        
        XCTAssertFalse(viewModel.profileImages.contains(where: {$0.id == 1 }))
    }
    
    func testUpdateProfileImagesWithError() {
        service.fetchEditFieldsError = false
        service.fetchProfileImagesError = false
        viewModel.getProfileUpdateFields()
        
        service.updateProfileImagesError = true
        viewModel.updateProfileImages(images: [""])
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testUpdateProfileImageWithSuccess() {
        service.fetchEditFieldsError = false
        service.fetchProfileImagesError = false
        viewModel.getProfileUpdateFields()
        
        service.updateProfileImagesError = false
        viewModel.updateProfileImages(images: [""])
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testSendVerificationCodeWithError() {
        service.sendVerificationError = true
        viewModel.sendVerificationCode()
        
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
        XCTAssertTrue(viewModel.showAlert)
    }
    
    func testSendVerificationCodeWithSuccess() {
        service.sendVerificationError = false
        viewModel.sendVerificationCode()
        
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testCheckVerificationCodeWithError() {
        service.checkVerificationCodeError = true
        viewModel.checkVerificationCode()
        
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testCheckVerificationCodeWithSuccess() {
        service.checkVerificationCodeError = false
        viewModel.checkVerificationCode()
        
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
}
