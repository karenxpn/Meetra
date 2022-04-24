//
//  MockUserService.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 29.03.22.
//

import Foundation
import Combine
import Alamofire
@testable import Meetra

class MockUserService: UserServiceProtocol {
    func reportUser(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: reportUserError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    func blockUser(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: blockUserError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    func fetchFriendRequests(page: Int) -> AnyPublisher<DataResponse<FriendRequestListModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchFriendRequestsError, response: friendRequests, responseType: FriendRequestListModel.self)
    }
    
    func accept_rejectFriendRequest(model: FriendRequestResponseRequest) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: accept_rejectError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    func fetchStarredUsers(page: Int) -> AnyPublisher<DataResponse<FavouritesListModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchStarredUsersError, response: users, responseType: FavouritesListModel.self)
    }
    
    
    var fetchUserError = false
    var sendFriendRequestError = false
    var starUserError = false
    var fetchStarredUsersError = false
    var fetchFriendRequestsError = false
    var accept_rejectError = false
    var blockUserError = false
    var reportUserError = false
    
    let globalResponse = GlobalResponse(status: "success", message: "success")
    let userModel = AppPreviewModels.userModel
    let users = AppPreviewModels.favouritesListModel
    let friendRequests = FriendRequestListModel(requests: [AppPreviewModels.friendRequestModel])
    
    func fetchUser(id: Int) -> AnyPublisher<DataResponse<UserModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchUserError, response: userModel, responseType: UserModel.self)
    }
    
    func sendFriendRequest(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: sendFriendRequestError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    func starUser(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: starUserError, response: globalResponse, responseType: GlobalResponse.self)
    }
}
