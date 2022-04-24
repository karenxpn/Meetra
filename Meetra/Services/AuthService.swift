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
}

class AuthService {
    static let shared: AuthServiceProtocol = AuthService()
    
    private init() { }
}

extension AuthService: AuthServiceProtocol {
    func signUpConfirm(model: RegistrationRequest) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth/confirm")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model, url: url, responseType: GlobalResponse.self)

    }
    
    func fetchInterests() -> AnyPublisher<DataResponse<InterestModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)interests")!
        
        return AF.request(url,
                          method: .get)
            .validate()
            .publishDecodable(type: InterestModel.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
        
        return AF.request(url,
                          method: .post,
                          parameters: ["phoneNumber": phoneNumber],
                          encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: AuthResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
