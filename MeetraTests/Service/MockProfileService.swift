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
    func updateProfileImages(token: String, images: [String]) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: updateProfileImagesError,
                                                     response: profileImages,
                                                     responseType: ProfileImageList.self)
    }
    
    func deleteProfileImage(token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: deleteProfileImageError,
                                                     response: globalResponse,
                                                     responseType: GlobalResponse.self)
    }
    
    func fetchProfileImages(token: String) -> AnyPublisher<DataResponse<ProfileImageList, NetworkError>, Never> {
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
    
    let networkError = NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)
    let fields = AppPreviewModels.fields
    let globalResponse = GlobalResponse(status: "", message: "")
    let profile = AppPreviewModels.profile
    let profileImages = AppPreviewModels.profileImages
    
    func fetchProfile(token: String) -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchProfileError, response: profile, responseType: ProfileModel.self)
    }
    
    func fetchProfileEditFields(token: String) -> AnyPublisher<DataResponse<ProfileEditFields, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchEditFieldsError, response: fields, responseType: ProfileEditFields.self)
    }
    
    func updateProfile(token: String, model: ProfileEditFields) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: updateProfileError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
}
