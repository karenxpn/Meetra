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
    func checkVerificationCode(phoneNumber: String, code: String ) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never>
    func resendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func fetchInterests() -> AnyPublisher<DataResponse<[InterestModel], NetworkError>, Never>
}

class AuthService {
    static let shared: AuthServiceProtocol = AuthService()
    
    private init() { }
}

extension AuthService: AuthServiceProtocol {
    func fetchInterests() -> AnyPublisher<DataResponse<[InterestModel], NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth/interests")!
        
        return AF.request(url,
                          method: .get)
            .validate()
            .publishDecodable(type: [InterestModel].self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    

    func resendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth/resend-code")!
        
        return AF.request(url,
                          method: .post,
                          parameters: ["phoneNumber": phoneNumber],
                          encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: GlobalResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func checkVerificationCode(phoneNumber: String, code: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth/check-verification-code")!
        
        return AF.request(url,
                          method: .post,
                          parameters: ["phoneNumber": phoneNumber,
                                       "code": code],
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
    
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<AuthResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)auth/sign-up")!
        
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
