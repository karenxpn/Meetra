//
//  NetworkError.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var message: String
}
