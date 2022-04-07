//
//  AlamofireAPIHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import Foundation
import Alamofire
import Combine


class AlamofireAPIHelper {
    static let shared = AlamofireAPIHelper()
    private init() { }
    
    func getRequest<T>(url: URL, headers: HTTPHeaders, responseType: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never> where T : Decodable {
        return AF.request(url,
                          method: .get,
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
    
    func postRequest<T, P>( params: P, url: URL, headers: HTTPHeaders, responseType: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never> where T : Decodable, P : Encodable {

        return AF.request(url,
                          method: .post,
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
    
    func patchRequest<T, P>( params: P, url: URL, headers: HTTPHeaders, responseType: T.Type) -> AnyPublisher<DataResponse<T, NetworkError>, Never> where T : Decodable, P : Encodable {

        return AF.request(url,
                          method: .patch,
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
