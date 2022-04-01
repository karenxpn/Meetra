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
}
