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
}

class ProfileService {
    static let shared: ProfileServiceProtocol = ProfileService()
    private init() { }
}

extension ProfileService: ProfileServiceProtocol {
    func fetchProfile(token: String) -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/me")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.getRequest(url: url, headers: headers, responseType: ProfileModel.self)
    }
}
