//
//  Constants.swift
//  FlickrSearchGallery
//
//  Created by Mahesh Sonaiya on 07/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

public struct Constants {
    static let APIKey = "3e7cc266ae2b0e0d78e279ce8e361736"
}

public struct NetworkConstants {
    static let BASEURL = "https://api.flickr.com"
    static let SearchMethod = "flickr.photos.search"
    static let JsonResponseFormat = "json"
}

public struct URLRequestConstants {
    static let URLMethod = "method"
    static let URLAPIKey = "api_key"
    static let URLResponseFormat = "format"
    static let URLNoJsonCallback = "nojsoncallback"
    static let URLSafeSearch = "safe_search"
    static let URLTextSearch = "text"
    static let URLPageParam = "page"
}
