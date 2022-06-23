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
    var fetchSignedUrlError: Bool = false
    func fetchSignedUrl(key: String) -> AnyPublisher<DataResponse<GetSignedUrlResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchSignedUrlError, response: signedUrlResponse, responseType: GetSignedUrlResponse.self)
    }
    
    func storeFileToServer(file: Data, url: String) -> AnyPublisher<DataResponse<Data?, AFError>, Never> {
        let result: Result<Data?, AFError> = Result<Data?, AFError>.failure(AFError.explicitlyCancelled)
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<Data?, AFError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    
    func signUpConfirm(model: RegistrationRequest) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: signUpConfirmError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    func fetchInterests() -> AnyPublisher<DataResponse<InterestModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchInterestsError, response: interests, responseType: InterestModel.self)
    }
    
    
    var sendVerificationCodeError: Bool = false
    var checkVerificationCodeError: Bool = false
    var fetchInterestsError: Bool = false
    var signUpConfirmError: Bool = false
    var storeFileError: Bool = false
    
    let globalResponse = GlobalResponse(status: "Success", message: "Success")
    let authResponse = AuthResponse(login: false, id: 1, accessToken: "")
    let interests = InterestModel(interests: ["asdf", "asdf"])
    let signedUrlResponse = GetSignedUrlResponse(url: "some url")
    
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: sendVerificationCodeError, response: authResponse, responseType: AuthResponse.self)
    }
    
    func checkVerificationCode(code: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: checkVerificationCodeError, response: authResponse, responseType: AuthResponse.self)
    }
    
    func resendVerificationCode() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let result = Result<GlobalResponse, NetworkError>.success(globalResponse)
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<GlobalResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
}
