//
//  UserService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import Foundation
import Alamofire
import Combine

protocol UserServiceProtocol {
    func fetchUser( token: String, id: Int ) -> AnyPublisher<DataResponse<UserModel, NetworkError>, Never>
    func sendFriendRequest( token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func starUser( token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func fetchStarredUsers( token: String, page: Int ) -> AnyPublisher<DataResponse<FavouritesListModel, NetworkError>, Never>
    func fetchFriendRequests( token: String, page: Int ) -> AnyPublisher<DataResponse<FriendRequestListModel, NetworkError>, Never>
    func accept_rejectFriendRequest( token: String, model: FriendRequestResponseRequest ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
}

class UserService {
    static let shared: UserServiceProtocol = UserService()
    private init() { }
}

extension UserService: UserServiceProtocol {
    func accept_rejectFriendRequest(token: String, model: FriendRequestResponseRequest ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/respond-request")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.postRequest(params: model, url: url, headers: headers, responseType: GlobalResponse.self)
    }
    
    func fetchFriendRequests(token: String, page: Int) -> AnyPublisher<DataResponse<FriendRequestListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/requests/\(page)")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.getRequest(url: url, headers: headers, responseType: FriendRequestListModel.self)
    }
    
    func fetchStarredUsers(token: String, page: Int) -> AnyPublisher<DataResponse<FavouritesListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/favourites/\(page)")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.getRequest(url: url, headers: headers, responseType: FavouritesListModel.self)
    }
    
    func sendFriendRequest(token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/friend")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.postRequest(params: ["id" : id], url: url, headers: headers, responseType: GlobalResponse.self)
    }
    
    func starUser(token: String, id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)starred-user")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.postRequest(params: ["userId" : id], url: url, headers: headers, responseType: GlobalResponse.self)
    }
    
    func fetchUser(token: String, id: Int) -> AnyPublisher<DataResponse<UserModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/\(id)")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.getRequest(url: url, headers: headers, responseType: UserModel.self)
    }
    
}
