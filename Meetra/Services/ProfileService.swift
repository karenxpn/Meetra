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
    func fetchProfileImages( token: String ) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never>
    func updateProfileImages(token: String, images: [String] ) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never>
    func deleteProfileImage( token: String, id: Int ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func updateProfile( token: String, model: ProfileEditFields ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    
    func signout( token: String ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func delete_account( token: String ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
}

class ProfileService {
    static let shared: ProfileServiceProtocol = ProfileService()
    private init() { }
}

extension ProfileService: ProfileServiceProtocol {
    func signout(token: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/signout")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, headers: headers, responseType: GlobalResponse.self)
    }
    
    func delete_account(token: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/delete")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, method: .delete, headers: headers, responseType: GlobalResponse.self)
    }
    
    func updateProfileImages(token: String, images: [String]) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/image")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["images" : images],
                                                     url: url,
                                                     headers: headers,
                                                     responseType: ProfileImageList.self)
    }
    
    func deleteProfileImage(token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/image/\(id)")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url,
                                                     method: .delete,
                                                     headers: headers,
                                                     responseType: GlobalResponse.self)
    }
    
    func fetchProfileImages(token: String) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/images")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, headers: headers, responseType: ProfileImageList.self)
    }
    
    func fetchProfileEditFields(token: String) -> AnyPublisher<DataResponse<ProfileEditFields, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/profile")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, headers: headers, responseType: ProfileEditFields.self)
    }
    
    func updateProfile(token: String, model: ProfileEditFields) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/profile")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model,
                                                     url: url,
                                                     method: .patch,
                                                     headers: headers,
                                                     responseType: GlobalResponse.self)
    }
    
    func fetchProfile(token: String) -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/me")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, headers: headers, responseType: ProfileModel.self)
    }
}
