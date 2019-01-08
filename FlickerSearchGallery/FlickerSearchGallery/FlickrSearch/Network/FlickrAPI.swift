//
//  FlickrAPI.swift
//  FlickrImageGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

// MARK: - ResultType Enum
public enum ResultType {
    case Success(response: FlickrGalleryResponse)
    case Error(error: ErrorResponse)
}

public struct ErrorResponse {
    var errorCode : Int
    var errorMessage : String
    
    init(errorCode: Int,errorMessage :String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}

class FlickrAPI {
    
    // MARK: - Properties
    var urlComponents: URLComponents
    var currentSearchTag: String? = nil
    var currentPage: Int = 1
    
    // MARK: - Object lifecycle
    init() {
        urlComponents = URLComponents(string: NetworkConstants.BASEURL)!
    }
    
    func buildRequestURL() {
        urlComponents.queryItems = [
            URLQueryItem(name: URLRequestConstants.URLMethod, value: NetworkConstants.SearchMethod),
            URLQueryItem(name: URLRequestConstants.URLAPIKey, value: Constants.APIKey),
            URLQueryItem(name: URLRequestConstants.URLResponseFormat, value: NetworkConstants.JsonResponseFormat),
            URLQueryItem(name: URLRequestConstants.URLNoJsonCallback, value: "1"),
            URLQueryItem(name: URLRequestConstants.URLSafeSearch, value: "1"),
            URLQueryItem(name: URLRequestConstants.URLPageParam, value: "\(currentPage)"),
            URLQueryItem(name: URLRequestConstants.URLTextSearch, value: currentSearchTag ?? "kittens")
        ]
    }
    
    // MARK: - Request for API
    func request(path: String, completion: @escaping(ResultType) -> Void ) {
        urlComponents.path = path
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { [weak self] data, response, error in
            guard error == nil else {
                let errorObj = ErrorResponse.init(errorCode: 100, errorMessage: error?.localizedDescription ?? "")
                completion(ResultType.Error(error: errorObj))
                return
            }
            self?.parseJsonResponse(data: data, completion: completion)
        }
        task.resume()
    }
    
    // MARK: - Parse Json Response
    func parseJsonResponse(data: Data?, completion: @escaping(ResultType) -> Void ) {
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
            let decoder = JSONDecoder()
            let item = try JSONSerialization.data(withJSONObject: json["photos"]!, options: [])
            let mediaArray = try decoder.decode(FlickrGalleryResponse.self, from: item)
            completion(ResultType.Success(response: mediaArray))
        } catch {
            let errorObj = ErrorResponse.init(errorCode: 100, errorMessage: error.localizedDescription)
            completion(ResultType.Error(error: errorObj))
        }
    }
}
