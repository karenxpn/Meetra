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
    func fetchUser(id: Int ) -> AnyPublisher<DataResponse<UserModel, NetworkError>, Never>
    func sendFriendRequest(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func starUser(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func fetchStarredUsers(page: Int ) -> AnyPublisher<DataResponse<FavouritesListModel, NetworkError>, Never>
    func fetchFriendRequests(page: Int ) -> AnyPublisher<DataResponse<FriendRequestListModel, NetworkError>, Never>
    func accept_rejectFriendRequest(model: FriendRequestResponseRequest ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func reportUser(id: Int ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func blockUser(id: Int ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
}

class UserService {
    static let shared: UserServiceProtocol = UserService()
    private init() { }
}

extension UserService: UserServiceProtocol {
    func reportUser(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/report")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["id" : id], url: url, responseType: GlobalResponse.self)
    }
    
    func blockUser(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/report")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["id" : id], url: url, responseType: GlobalResponse.self)
    }
    
    func accept_rejectFriendRequest(model: FriendRequestResponseRequest ) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/respond-request")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model, url: url, responseType: GlobalResponse.self)
    }
    
    func fetchFriendRequests(page: Int) -> AnyPublisher<DataResponse<FriendRequestListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/requests/\(page)")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: FriendRequestListModel.self)
    }
    
    func fetchStarredUsers(page: Int) -> AnyPublisher<DataResponse<FavouritesListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/favourites/\(page)")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: FavouritesListModel.self)
    }
    
    func sendFriendRequest(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/friend")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["id" : id], url: url, responseType: GlobalResponse.self)
    }
    
    func starUser( id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)starred-user")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["userId" : id], url: url, responseType: GlobalResponse.self)
    }
    
    func fetchUser(id: Int) -> AnyPublisher<DataResponse<UserModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/\(id)")!
        
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: UserModel.self)
    }
    
}
