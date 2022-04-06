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
    
    var fetchProfileError: Bool = false
    let networkError = NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)
    let profile = AppPreviewModels.profile
    
    func fetchProfile(token: String) -> AnyPublisher<DataResponse<ProfileModel, NetworkError>, Never> {
        
        return AlamofireAPIHelper.shared.mockRequest(error: fetchProfileError, response: profile, responseType: ProfileModel.self)
    } 
}
