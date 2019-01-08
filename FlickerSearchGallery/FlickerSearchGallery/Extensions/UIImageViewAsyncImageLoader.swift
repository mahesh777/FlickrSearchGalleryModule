//
//  UIImageViewAsyncImageLoader.swift
//  FlickrSearchGallery
//
//  Created by Mahesh Sonaiya on 07/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import Foundation
import UIKit

var imageCache = NSCache<NSString, AnyObject>()

// MARK: - UIImageView async images download

extension UIImageView {
    func setImageWithURL(url: URL) {
        self.tag = url.hashValue
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        DispatchQueue.global().async {
            let imageURL = url
            guard let imageData = try? Data(contentsOf:url) else { return }
            let image = UIImage(data: imageData)
            imageCache.setObject(image!, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                if self.tag == imageURL.hashValue {
                    self.image  = image
                }
            }
        }
    }
}
