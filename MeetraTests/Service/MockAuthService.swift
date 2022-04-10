//
//  MockAuthService.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 03.03.22.
//

import Foundation
import Alamofire
import Combine
@testable import Meetra

class MockAuthServie: AuthServiceProtocol {
    
    func signUpConfirm(model: RegistrationRequest, token: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: signUpConfirmError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    func fetchInterests() -> AnyPublisher<DataResponse<InterestModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchInterestsError, response: interests, responseType: InterestModel.self)
    }
    
    
    var sendVerificationCodeError: Bool = false
    var checkVerificationCodeError: Bool = false
    var fetchInterestsError: Bool = false
    var signUpConfirmError: Bool = false
    
    let globalResponse = GlobalResponse(status: "Success", message: "Success")
    let authResponse = AuthResponse(login: false, accessToken: "")
    let interests = InterestModel(interests: ["asdf", "asdf"])
    
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: sendVerificationCodeError, response: authResponse, responseType: AuthResponse.self)
    }
    
    func checkVerificationCode(token: String, code: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: checkVerificationCodeError, response: authResponse, responseType: AuthResponse.self)
    }
    
    func resendVerificationCode(token: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let result = Result<GlobalResponse, NetworkError>.success(globalResponse)
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<GlobalResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
}
