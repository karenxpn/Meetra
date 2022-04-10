//
//  PlacesService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 18.03.22.
//

import Foundation
import Alamofire
import SocketIO
import Combine

protocol PlacesServiceProtocol {
    func fetchPlaceRoom( token: String, model: PlaceRoomRequest ) -> AnyPublisher<DataResponse<PlaceRoom, NetworkError>, Never>
    func fetchSwipes(token: String, page: Int, model: PlaceRoomRequest) -> AnyPublisher<DataResponse<SwipeUserListModel, NetworkError>, Never>
}

class PlacesService {
    static let shared: PlacesServiceProtocol = PlacesService()
    
    private init() { }
}

extension PlacesService: PlacesServiceProtocol {
    func fetchSwipes(token: String, page: Int, model: PlaceRoomRequest) -> AnyPublisher<DataResponse<SwipeUserListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/swipes/\(page)")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model, url: url, headers: headers, responseType: SwipeUserListModel.self)
    }
    
    func fetchPlaceRoom(token: String, model: PlaceRoomRequest) -> AnyPublisher<DataResponse<PlaceRoom, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/place")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model, url: url, headers: headers, responseType: PlaceRoom.self)
    }
}
