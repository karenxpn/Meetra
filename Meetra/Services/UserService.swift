//
//  UserService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import Foundation
import Alamofire
import Combine

protocol UserServiceProtocol {
    func fetchUser( token: String, id: Int ) -> AnyPublisher<DataResponse<UserModel, NetworkError>, Never>
    func sendFriendRequest( token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func starUser( token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
}

class UserService {
    static let shared: UserServiceProtocol = UserService()
    private init() { }
}

extension UserService: UserServiceProtocol {
    func sendFriendRequest(token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/\(id)/request")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AF.request(url,
                          method: .post,
                          headers: headers)
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
    
    func starUser(token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)starred-user")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AF.request(url,
                          method: .post,
                          parameters: ["userId" : id],
                          encoder: JSONParameterEncoder.default,
                          headers: headers)
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
    
    func fetchUser(token: String, id: Int) -> AnyPublisher<DataResponse<UserModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/\(id)")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AF.request(url,
                          method: .get,
                          headers: headers)
            .validate()
            .publishDecodable(type: UserModel.self)
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
