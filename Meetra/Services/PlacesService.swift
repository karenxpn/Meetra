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
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model, url: url, responseType: SwipeUserListModel.self)
    }
    
    func fetchPlaceRoom(token: String, model: PlaceRoomRequest) -> AnyPublisher<DataResponse<PlaceRoom, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/place")!
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: model, url: url, responseType: PlaceRoom.self)
    }
}
