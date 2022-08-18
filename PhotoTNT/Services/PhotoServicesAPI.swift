//
//  PhotoServicesAPI.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

import Foundation
import Combine


class PhotoURLSessionAPI: PhotosProtocol {

    let baseURL: String
    let urlSession: URLSession

    init(baseURL: String) {
        let urlSessionConfiguration = URLSessionConfiguration.default
        self.baseURL = baseURL
        self.urlSession = URLSession(configuration: urlSessionConfiguration)
    }

    func fetchPhotos(request: Photo.FetchPhotos.RequestPaginated, completionHandler: @escaping ([Photo.FetchPhotos.Response]?, APIError?) -> Void) {
        call(endpoint: API.photos(start: request.start, limit: request.limit), completionHandler: completionHandler)
    }

    func fetchPhotos(completionHandler: @escaping ([Photo.FetchPhotos.Response]?, APIError?) -> Void) {
        call(endpoint: API.allPhotos, completionHandler: completionHandler)
    }

    private func call<Response>(endpoint: APICall, httpCodes: HTTPCodes = .success, completionHandler: @escaping (Response?, APIError?) -> Void) {
        let jsonDecoder = JSONDecoder()
        if let url = URL(string: baseURL + endpoint.path) {
            urlSession.dataTask(with: url) { data, response, error in
                guard let codedData = data else {
                    if let error = error {
                        print("Error \(String(describing: error))")
                    }
                    completionHandler(nil, APIError.unexpectedResponse)
                    return
                }
                do {
                    let decodeResponse = try jsonDecoder.decode([Photo.FetchPhotos.Response].self, from: codedData)
                    print(decodeResponse)
                    guard let photosResponse = decodeResponse as? Response else {
                        completionHandler(nil, APIError.deserialization)
                        return
                    }
                    completionHandler(photosResponse, nil)
                } catch let error {
                    print("Error \(String(describing: error))")
                    completionHandler(nil, APIError.deserialization)
                }
            }.resume()
        }
    }
}

extension PhotoURLSessionAPI {
    enum API {
        case allPhotos
        case photos(start: Int, limit: Int)
    }
}

extension PhotoURLSessionAPI.API: APICall {
    var path: String {
        switch self {
        case .allPhotos:
            return "/photos"
        case let .photos(start, limit):
            return "/photos?_start=\(start.description)&_limit=\(limit.description)"
        }
    }
    var method: String {
        "GET"
    }
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    func body() throws -> Data? {
        return nil
    }
}
