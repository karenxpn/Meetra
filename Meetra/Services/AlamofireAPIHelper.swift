//
//  AlamofireAPIHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import Foundation
import Alamofire
import Combine
import SwiftUI

class AlamofireAPIHelper {
    static let shared = AlamofireAPIHelper()
    
    @AppStorage("token") var token: String = ""
    @AppStorage( "initialToken" ) var initialToken: String = ""
    
    private init() { }
    
    func get_deleteRequest<T>(url: URL,
                              method: HTTPMethod = .get,
                              responseType: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never> where T : Decodable {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token == "" ? initialToken : token)"]
        
        return AF.request(url,
                          method: method,
                          headers: headers)
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func post_patchRequest<T, P>( params: P,
                                  url: URL,
                                  method: HTTPMethod = .post,
                                  responseType: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never> where T : Decodable, P : Encodable {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token == "" ? initialToken : token)"]

        return AF.request(url,
                          method: method,
                          parameters: params,
                          encoder: JSONParameterEncoder.default,
                          headers: headers)
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    let networkError = NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)
    func mockRequest<T>( error: Bool, response: T, responseType: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never> where T : Codable {

        var result: Result<T, NetworkError>
        
        if error    { result = Result<T, NetworkError>.failure(networkError)}
        else        { result = Result<T, NetworkError>.success(response)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<T, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
}
