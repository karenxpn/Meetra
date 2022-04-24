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
    func fetchProfile() -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never>
    func fetchProfileEditFields() -> AnyPublisher<DataResponse<ProfileEditFields, NetworkError>, Never>
    func fetchProfileImages() -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never>
    func updateProfileImages(images: [String] ) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never>
    func deleteProfileImage(id: Int ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func updateProfile(model: ProfileEditFields ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func checkVerificationCode(phoneNumber: String, code: String ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    
    func signout() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func delete_account() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
}

class ProfileService {
    static let shared: ProfileServiceProtocol = ProfileService()
    private init() { }
}

extension ProfileService: ProfileServiceProtocol {
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/phone-number")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["phoneNumber" : phoneNumber],
                                                           url: url,
                                                           method: .patch,
                                                           responseType: GlobalResponse.self)
    }
    
    func checkVerificationCode(phoneNumber: String, code: String ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/change-phone-number")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["phoneNumber" : phoneNumber,
                                                                    "otp": code],
                                                           url: url,
                                                           method: .patch,
                                                           responseType: GlobalResponse.self)
    }
    
    func signout() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/signout")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: GlobalResponse.self)
    }
    
    func delete_account() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/me")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, method: .delete, responseType: GlobalResponse.self)
    }
    
    func updateProfileImages(images: [String]) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/image")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["images" : images],
                                                           url: url,
                                                           responseType: ProfileImageList.self)
    }
    
    func deleteProfileImage(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/image/\(id)")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url,
                                                           method: .delete,
                                                           responseType: GlobalResponse.self)
    }
    
    func fetchProfileImages() -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/images")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: ProfileImageList.self)
    }
    
    func fetchProfileEditFields() -> AnyPublisher<DataResponse<ProfileEditFields, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/profile")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: ProfileEditFields.self)
    }
    
    func updateProfile(model: ProfileEditFields) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/profile")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model,
                                                           url: url,
                                                           method: .patch,
                                                           responseType: GlobalResponse.self)
    }
    
    func fetchProfile() -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/me")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: ProfileModel.self)
    }
}
