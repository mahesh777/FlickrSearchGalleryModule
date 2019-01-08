//
//  FlickrMedia.swift
//  FlickrImageGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

// MARK: - FlickrMedia Json Class for Photos
public struct FlickrMedia: Codable {
    var id: String
    var owner: String
    var farm: Int
    var secret: String
    var server: String
    var title: String
    var isfriend: Int
    var ispublic: Int
    var isfamily: Int
}


