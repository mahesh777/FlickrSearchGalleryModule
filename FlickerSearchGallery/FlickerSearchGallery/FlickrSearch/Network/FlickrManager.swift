//
//  FlickrManager.swift
//  FlickrSearchGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

public class FlickrManager {
    private let dataProvider = NetworkFlickrDataProvider.networkDataprovider
    
    public func searchFlickrImages(_ searchTag: String?,
                                   pageNo: Int,
                                   with success: @escaping (FlickrGalleryResponse) -> Void,
                                   with errorCode: @escaping (ErrorResponse) -> Void) {
        dataProvider.searchFlickrImages(searchTag,
                                        pageNo: pageNo,
                                        with: { (flickrArray) in
            success(flickrArray)
        }) { (error) in
            errorCode(error)
        }
    }
}
