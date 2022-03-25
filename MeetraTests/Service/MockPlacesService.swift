//
//  PlacesService.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 23.03.22.
//

import Foundation
@testable import Meetra
import Alamofire
import Combine
import SocketIO


class MockPlacesService: PlacesServiceProtocol {
    
    var fetchPlaceRoomError: Bool = false
    
    let networkError = NetworkError(initialError: AFError.explicitlyCancelled, backendError: nil)
    let placeRoom = PlaceRoom(users: [UserPreviewModel(id: 1, image: "", name: "Karen", online: true)], count: 1, place: "EVN")

    func fetchPlaceRoom(token: String, model: PlaceRoomRequest) -> AnyPublisher<DataResponse<PlaceRoom, NetworkError>, Never> {
        var result: Result<PlaceRoom, NetworkError>
        
        if fetchPlaceRoomError  { result = Result<PlaceRoom, NetworkError>.failure(networkError)}
        else                    { result = Result<PlaceRoom, NetworkError>.success(placeRoom)}
        
        let response = DataResponse(request: nil, response: nil, data: nil, metrics: nil, serializationDuration: 0, result: result)
        let publisher = CurrentValueSubject<DataResponse<PlaceRoom, NetworkError>, Never>(response)
        return publisher.eraseToAnyPublisher()
    }
        
}
