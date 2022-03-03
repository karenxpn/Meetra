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
    
    var sendVerificationCodeError: Bool = false
    var checkVerificationCodeError: Bool = false
    
    let globalResponse = GlobalResponse(status: "Success", message: "Success")
    let authResponse = AuthResponse(token: "")
    let networkError = NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)
    
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        var result: Result<AuthResponse, NetworkError>
        
        if sendVerificationCodeError    { result = Result<AuthResponse, NetworkError>.failure(networkError)}
        else                            { result = Result<AuthResponse, NetworkError>.success(authResponse)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<AuthResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    func checkVerificationCode(phoneNumber: String, code: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        var result: Result<AuthResponse, NetworkError>
        
        if checkVerificationCodeError   { result = Result<AuthResponse, NetworkError>.failure(networkError)}
        else                            { result = Result<AuthResponse, NetworkError>.success(authResponse)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<AuthResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    func resendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let result = Result<GlobalResponse, NetworkError>.success(globalResponse)
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<GlobalResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
}
