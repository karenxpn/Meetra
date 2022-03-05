//
//  AuthViewModelTests.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 03.03.22.
//

import Foundation
@testable import Meetra
import XCTest

class AuthViewModelTests: XCTestCase {
    
    var service: MockAuthServie!
    var viewModel: AuthViewModel!
    
    override func setUp() {
        self.service = MockAuthServie()
        self.viewModel = AuthViewModel(dataManager: self.service)
    }
    
    func testSendVerificationCodeWithError() {
        service.sendVerificationCodeError = true
        viewModel.sendVerificationCode()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testSendVerificationCodeWithSuccess() {
        service.sendVerificationCodeError = false
        viewModel.sendVerificationCode()
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
    func testCheckVerificationCodeWithError() {
        service.checkVerificationCodeError = true
        viewModel.checkVerificationCode(phone: "", code: "")
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testCheckVerificationCodeWithSuccess() {
        service.checkVerificationCodeError = false
        viewModel.checkVerificationCode(phone: "", code: "")
        
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
        XCTAssertFalse(viewModel.showAlert)
    }
    
    
    func testGetInterestsWithError() {
        service.fetchInterestsError = true
        viewModel.getInterests()
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testGetInterestsWithSuccess() {
        service.fetchInterestsError = false
        viewModel.getInterests()
        
        XCTAssertFalse(viewModel.interests.isEmpty)
    }
    
    func testSignUpConfirmWithError() {
        service.signUpConfirmError = true
        viewModel.confirmSignUp(model: RegistrationRequest())
        
        XCTAssertTrue(viewModel.showAlert)
        XCTAssertFalse(viewModel.alertMessage.isEmpty)
    }
    
    func testSignUpConfirmWithSuccess() {
        service.signUpConfirmError = false
        viewModel.confirmSignUp(model: RegistrationRequest())
        
        XCTAssertFalse(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.isEmpty)
    }
    
}
