//
//  ProfileService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import Foundation
import Alamofire
import Combine

protocol ProfileServiceProtocol {
    func fetchProfile( token: String ) -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never>
    func fetchProfileEditFields( token: String ) -> AnyPublisher<DataResponse<ProfileEditFields, NetworkError>, Never>
    func updateProfile( token: String, model: ProfileEditFields ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
}

class ProfileService {
    static let shared: ProfileServiceProtocol = ProfileService()
    private init() { }
}

extension ProfileService: ProfileServiceProtocol {
    func fetchProfileEditFields(token: String) -> AnyPublisher<DataResponse<ProfileEditFields, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/me/edit")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.getRequest(url: url, headers: headers, responseType: ProfileEditFields.self)
    }
    
    func updateProfile(token: String, model: ProfileEditFields) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/me/edit")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.patchRequest(params: model, url: url, headers: headers, responseType: GlobalResponse.self)
    }
    
    func fetchProfile(token: String) -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/me")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.getRequest(url: url, headers: headers, responseType: ProfileModel.self)
    }
}
