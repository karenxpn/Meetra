//
//  LocationService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 19.10.22.
//

import Foundation
import Alamofire
import Combine

protocol LocationServiceProtocol {
    func fetchRegions(lat: Double, lng: Double) -> AnyPublisher<DataResponse<RegionListModel, NetworkError>, Never>
    func sendRegionState(identifier: String, state: Bool) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
}


class LocationService {
    static let shared: LocationServiceProtocol = LocationService()
    private init() { }
}

extension LocationService: LocationServiceProtocol {
    func sendRegionState(identifier: String, state: Bool) -> AnyPublisher<Alamofire.DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)users/update-place")!
        let params = RegionStateModel(place_id: identifier, inside: state)
        return AlamofireAPIHelper.shared.post_patchRequest(params: params, url: url, responseType: GlobalResponse.self)
    }
    
    func fetchRegions(lat: Double, lng: Double) -> AnyPublisher<Alamofire.DataResponse<RegionListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)regions")!
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["lat": lat, "lng": lng], url: url, responseType: RegionListModel.self)
    }
}
