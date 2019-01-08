//
//  FlickrUtility.swift
//  FlickrSearchGallery
//
//  Created by Mahesh Sonaiya on 08/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation

class FlickrUtility {
    static func isConnectedToInternet() ->Bool {
        if NetworkReachabilityManager()!.isReachable {
            return NetworkReachabilityManager()!.isReachable
        }else{
            return NetworkReachabilityManager()!.isReachable
        }
    }
}
