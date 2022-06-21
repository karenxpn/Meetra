//
//  AuthService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import Foundation
import Combine
import Alamofire

protocol AuthServiceProtocol {
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never>
    func checkVerificationCode(code: String ) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never>
    func resendVerificationCode() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func fetchInterests() -> AnyPublisher<DataResponse<InterestModel, NetworkError>, Never>
    func signUpConfirm(model: RegistrationRequest) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    
    func fetchSignedUrl(key: String) -> AnyPublisher<DataResponse<GetSignedUrlResponse, NetworkError>, Never>
    func storeFileToServer(file: Data, url: String) -> AnyPublisher<DataResponse<Data?, AFError>, Never>
}

class AuthService {
    static let shared: AuthServiceProtocol = AuthService()
    
    private init() { }
}

extension AuthService: AuthServiceProtocol {
    
    func storeFileToServer(file: Data, url: String) -> AnyPublisher<DataResponse<Data?, AFError>, Never> {
        return AF.upload(file, to: url, method: .put)
            .validate()
            .publishDecodable()
            .eraseToAnyPublisher()
    }
    
    func fetchSignedUrl(key: String) -> AnyPublisher<DataResponse<GetSignedUrlResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)aws/pre-signed-url")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["key" : key], url: url, responseType: GetSignedUrlResponse.self)
    }
    
    func signUpConfirm(model: RegistrationRequest) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth/confirm")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model, url: url, responseType: GlobalResponse.self)

    }
    
    func fetchInterests() -> AnyPublisher<DataResponse<InterestModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)interests")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: InterestModel.self)
    }
    
    
    func resendVerificationCode() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth/resend-code")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: GlobalResponse.self)
    }
    
    func checkVerificationCode(code: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth/check-code")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["otp" : code], url: url, responseType: AuthResponse.self)
    }
    
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["phoneNumber": phoneNumber],
                                                           url: url,
                                                           responseType: AuthResponse.self)
    }
}
