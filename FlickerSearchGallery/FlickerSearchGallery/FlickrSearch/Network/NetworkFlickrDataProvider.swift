//
//  NetworkFlickrDataProvider.swift
//  FlickrSearchGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

public class NetworkFlickrDataProvider : FlickrDataProvider {
    static let networkDataprovider = NetworkFlickrDataProvider()
    fileprivate static let path = "/services/rest/"
    fileprivate let flickrAPIManager = FlickrAPI()
    
    public func searchFlickrImages(_ searchTag: String?,
                                   pageNo: Int,
                                   with success: @escaping (FlickrGalleryResponse) -> Void,
                                   with errorCode: @escaping (ErrorResponse) -> Void) {
        
        if !FlickrUtility.isConnectedToInternet() {
            errorCode(ErrorResponse.init(errorCode: 100, errorMessage: "Network not available."))
            return
        }
        
        flickrAPIManager.currentSearchTag = searchTag
        flickrAPIManager.currentPage = pageNo
        flickrAPIManager.buildRequestURL()
        flickrAPIManager.request(path: NetworkFlickrDataProvider.path) { (response) in
            switch response {
            case .Success(let flickrMediaArray):
                success(flickrMediaArray)
            case .Error(let error):
                errorCode(error)
            }
        }
    }
}
