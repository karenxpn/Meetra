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
    var fetchSwipesError: Bool = false
    
    let placeRoom = PlaceRoom(users: [UserPreviewModel(id: 1, image: "", name: "Karen", age: 22, online: true)], chat: PlaceChat(id: 1, name: "EVN", isGroup: true, members: 3, online: 3, left: false))
    let swipes = SwipeUserListModel(users: [AppPreviewModels.swipeUser])

    func fetchPlaceRoom(model: PlaceRoomRequest) -> AnyPublisher<DataResponse<PlaceRoom, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchPlaceRoomError, response: placeRoom, responseType: PlaceRoom.self)
    }
    
    func fetchSwipes(page: Int, model: PlaceRoomRequest) -> AnyPublisher<DataResponse<SwipeUserListModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchSwipesError, response: swipes, responseType: SwipeUserListModel.self)
    }
}
