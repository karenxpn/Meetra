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
    
    func fetchStarredUsers(token: String, page: Int) -> AnyPublisher<DataResponse<FavouritesListModel, NetworkError>, Never> {
        var result: Result<FavouritesListModel, NetworkError>
        
        if fetchStarredUsersError   { result = Result<FavouritesListModel, NetworkError>.failure(networkError)}
        else                        { result = Result<FavouritesListModel, NetworkError>.success(users)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<FavouritesListModel, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    
    var fetchUserError = false
    var sendFriendRequestError = false
    var starUserError = false
    var fetchStarredUsersError = false
    
    let globalResponse = GlobalResponse(status: "success", message: "success")
    let networkError = NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)
    let userModel = AppPreviewModels.userModel
    let users = AppPreviewModels.favouritesListModel
    
    func fetchUser(token: String, id: Int) -> AnyPublisher<DataResponse<UserModel, NetworkError>, Never> {
        var result: Result<UserModel, NetworkError>
        
        if fetchUserError   { result = Result<UserModel, NetworkError>.failure(networkError)}
        else                { result = Result<UserModel, NetworkError>.success(userModel)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<UserModel, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    func sendFriendRequest(token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        var result: Result<GlobalResponse, NetworkError>
        
        if sendFriendRequestError   { result = Result<GlobalResponse, NetworkError>.failure(networkError)}
        else                        { result = Result<GlobalResponse, NetworkError>.success(globalResponse)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<GlobalResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
    
    func starUser(token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        var result: Result<GlobalResponse, NetworkError>
        
        if starUserError   { result = Result<GlobalResponse, NetworkError>.failure(networkError)}
        else               { result = Result<GlobalResponse, NetworkError>.success(globalResponse)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<GlobalResponse, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }    
}
