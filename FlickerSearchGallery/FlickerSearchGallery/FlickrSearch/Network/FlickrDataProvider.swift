//
//  FlickerDataProvider.swift
//  FlickerSearchGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

public protocol FlickrDataProvider {
    
    func searchFlickrImages(_ searchTag: String?,
                              pageNo: Int,
                              with success:@escaping (FlickrGalleryResponse)->Void,
                              with errorCode:@escaping (ErrorResponse)->Void) -> Void
}
