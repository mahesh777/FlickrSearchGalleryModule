//
//  FlickrGalleryResponse.swift
//  FlickrSearchGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

// MARK: - FlickrGalleryResponse Json Class for Gallery response
public struct FlickrGalleryResponse: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [FlickrMedia]
}
