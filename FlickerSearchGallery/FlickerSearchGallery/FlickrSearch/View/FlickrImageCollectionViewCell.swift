//
//  FlickrImageCollectionViewCell.swift
//  FlickrSearchGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class FlickrImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var flickrImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    open func setUpCell(media : FlickrMedia) {
        if let url = URL.init(string: returnImageURL(media: media)) {
            if flickrImageView.image != nil {
                flickrImageView.image = nil
                flickrImageView.image = UIImage.init(named: "ic_image_placeholder")
            }
            flickrImageView.setImageWithURL(url: url)
        }
    }
    
    func returnImageURL(media : FlickrMedia) ->  String {
        let mutableString = NSMutableString.init()
        mutableString.append("http://farm")
        mutableString.append("\(media.farm).")
        mutableString.append("static.flickr.com/")
        mutableString.append("\(media.server)/")
        mutableString.append("\(media.id)_\(media.secret).jpg")
        return mutableString.description
    }
}
