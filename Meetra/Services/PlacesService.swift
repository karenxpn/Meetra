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
    func sendLocation(socket: SocketIOClient, lat: CGFloat, lng: CGFloat)
    func fetchLocationResponse(socket: SocketIOClient, completion: @escaping (Bool) -> ())
    func fetchPlaceRoom( token: String, model: PlaceRoomRequest ) -> AnyPublisher<DataResponse<PlaceRoom, NetworkError>, Never>
}

class PlacesService {
    static let shared: PlacesServiceProtocol = PlacesService()
    
    private init() { }
}

extension PlacesService: PlacesServiceProtocol {
    func fetchPlaceRoom(token: String, model: PlaceRoomRequest) -> AnyPublisher<DataResponse<PlaceRoom, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)place")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        
        return AF.request(url,
                          method: .post,
                          parameters: model,
                          encoder: JSONParameterEncoder.default,
                          headers: headers)
            .validate()
            .publishDecodable(type: PlaceRoom.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchLocationResponse(socket: SocketIOClient,completion: @escaping (Bool) -> ()) {
        socket.on("location") { (data, ack) in
            print(data)
//            if let data = data[0] as? [String : Bool], let status = data["location"] {
//                DispatchQueue.main.async {
//                    completion(status)
//                }
//            }
        }
    }
    
    func sendLocation(socket: SocketIOClient, lat: CGFloat, lng: CGFloat) {
        socket.emit("location", ["lat" : lat,
                                 "lng": lng])
    }
}
