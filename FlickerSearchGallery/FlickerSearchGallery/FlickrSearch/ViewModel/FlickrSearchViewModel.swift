//
//  FlickrSearchViewModel.swift
//  FlickrSearchGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class FlickrSearchViewModel {
    let flickrManager = FlickrManager()
    var flickrGalleryResponse : FlickrGalleryResponse? = nil
    var errorResponse : ErrorResponse? = nil
    var pageNo : Int = 1
    var hasMoreItems : Bool = false

    func searchImagesFromFlicr(search : String?,
                               isFirstTime : Bool,
                               with success: @escaping (FlickrGalleryResponse) -> Void,
                               with errorCode: @escaping (ErrorResponse) -> Void)   {
        
        hasMoreItems = false
        flickrManager.searchFlickrImages(search,
                                         pageNo: pageNo,
                                         with: { [weak self] (flickrGalleryResponse) in
                                            
            guard let strongSelf = self else { return }
            
            strongSelf.manageAPIResponse(flickrGalleryResponse: flickrGalleryResponse,
                                         isFirstTime: isFirstTime)
                                            
            print(strongSelf.flickrGalleryResponse?.photo.count ?? 0)
            success(flickrGalleryResponse)
        }) { [weak self] (errorResponse) in
            guard let strongSelf = self else { return }
            strongSelf.errorResponse = errorResponse
            errorCode(errorResponse)
        }
    }
    
    func manageAPIResponse(flickrGalleryResponse : FlickrGalleryResponse, isFirstTime : Bool) {
        if isFirstTime {
            self.flickrGalleryResponse = flickrGalleryResponse
        } else {
            self.flickrGalleryResponse?.page = flickrGalleryResponse.page
            self.flickrGalleryResponse?.pages = flickrGalleryResponse.pages
            self.flickrGalleryResponse?.perpage = flickrGalleryResponse.perpage
            self.flickrGalleryResponse?.total = flickrGalleryResponse.total
            self.flickrGalleryResponse?.photo.append(contentsOf: flickrGalleryResponse.photo)
        }
        
        hasMoreItems = (flickrGalleryResponse.pages >= pageNo) ? true : false
    }
}
