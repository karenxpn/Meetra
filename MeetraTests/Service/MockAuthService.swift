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
        var result: Result<GlobalResponse, NetworkError>
        
        if signUpConfirmError   { result = Result<GlobalResponse, NetworkError>.failure(networkError)}
        else                    { result = Result<GlobalResponse, NetworkError>.success(globalResponse)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<GlobalResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    func fetchInterests() -> AnyPublisher<DataResponse<InterestModel, NetworkError>, Never> {
        var result: Result<InterestModel, NetworkError>
        
        if fetchInterestsError  { result = Result<InterestModel, NetworkError>.failure(networkError)}
        else                    { result = Result<InterestModel, NetworkError>.success(interests)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<InterestModel, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    
    var sendVerificationCodeError: Bool = false
    var checkVerificationCodeError: Bool = false
    var fetchInterestsError: Bool = false
    var signUpConfirmError: Bool = false
    
    let globalResponse = GlobalResponse(status: "Success", message: "Success")
    let authResponse = AuthResponse(login: false, accessToken: "")
    let networkError = NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)
    let interests = InterestModel(interests: ["asdf", "asdf"])
    
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        var result: Result<AuthResponse, NetworkError>
        
        if sendVerificationCodeError    { result = Result<AuthResponse, NetworkError>.failure(networkError)}
        else                            { result = Result<AuthResponse, NetworkError>.success(authResponse)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<AuthResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    func checkVerificationCode(token: String, code: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        var result: Result<AuthResponse, NetworkError>
        
        if checkVerificationCodeError   { result = Result<AuthResponse, NetworkError>.failure(networkError)}
        else                            { result = Result<AuthResponse, NetworkError>.success(authResponse)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<AuthResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    func resendVerificationCode(token: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let result = Result<GlobalResponse, NetworkError>.success(globalResponse)
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<GlobalResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
}
