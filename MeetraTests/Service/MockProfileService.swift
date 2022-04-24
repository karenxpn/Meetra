//
//  MockProfileService.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 06.04.22.
//

import Foundation
import Alamofire
import Combine

@testable import Meetra

class MockProfileService: ProfileServiceProtocol {
    func sendVerificationCode(phoneNumber: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: sendVerificationError,
                                                     response: globalResponse,
                                                     responseType: GlobalResponse.self)
    }
    
    func checkVerificationCode(phoneNumber: String, code: String) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: checkVerificationCodeError,
                                                     response: globalResponse,
                                                     responseType: GlobalResponse.self)
    }
    
    func signout() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: logoutError,
                                                     response: globalResponse,
                                                     responseType: GlobalResponse.self)
    }
    
    func delete_account() -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: deleteAccountError,
                                                     response: globalResponse,
                                                     responseType: GlobalResponse.self)
    }
    
    func updateProfileImages(images: [String]) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: updateProfileImagesError,
                                                     response: profileImages,
                                                     responseType: ProfileImageList.self)
    }
    
    func deleteProfileImage(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: deleteProfileImageError,
                                                     response: globalResponse,
                                                     responseType: GlobalResponse.self)
    }
    
    func fetchProfileImages() -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchProfileImagesError,
                                                     response: profileImages,
                                                     responseType: ProfileImageList.self)
    }
    
    
    var fetchProfileError: Bool = false
    var fetchEditFieldsError: Bool = false
    var fetchProfileImagesError: Bool = false
    var updateProfileError: Bool = false
    var updateProfileImagesError: Bool = false
    var deleteProfileImageError: Bool = false
    var deleteAccountError: Bool = false
    var logoutError: Bool = false
    var sendVerificationError: Bool = false
    var checkVerificationCodeError: Bool = false
    
    let networkError = NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)
    let fields = AppPreviewModels.fields
    let globalResponse = GlobalResponse(status: "", message: "")
    let profile = AppPreviewModels.profile
    let profileImages = AppPreviewModels.profileImages
    
    func fetchProfile() -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchProfileError, response: profile, responseType: ProfileModel.self)
    }
    
    func fetchProfileEditFields() -> AnyPublisher<DataResponse<ProfileEditFields, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchEditFieldsError, response: fields, responseType: ProfileEditFields.self)
    }
    
    func updateProfile(model: ProfileEditFields) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: updateProfileError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
}
