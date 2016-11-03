//
//  CacheHelper.swift
//  Recipes
//
//  Created by Ori Dahan on 06/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Kingfisher

class KingfisherHelper {

    static let sharedInstance = KingfisherHelper()
    
    fileprivate var cache: ImageCache
    
    fileprivate init() {
        self.cache = KingfisherManager.shared.cache
    }
    
    //--------------------------------------
    // MARK: - Images
    //--------------------------------------
    func setImageWithUrl(_ imageView: UIImageView, url: String) {
        
        let activityIndicator = ActivityIndicator(smallActivityView: imageView)
        activityIndicator.show()
        
//        imageView.kf_showIndicatorWhenLoading = true
        imageView.kf.setImage(with: URL(string: url)!,
                                     placeholder: UIImage(named: "placeholder-bg.png"),
                                     options: [
                                        .transition(.fade(0.3)),
                                        .backgroundDecode
                                     ],
                                     progressBlock: { (receivedSize, totalSize) -> () in
//                                        print("Download Progress: \(receivedSize)/\(totalSize)")
                                        if receivedSize == totalSize {
                                            activityIndicator.hide()
                                        }
                                     },
                                     completionHandler: { (image, error, cacheType, imageURL) -> () in
                                        activityIndicator.hide()
//                                        print("Downloaded and set!")
                                        if error != nil || image == nil {
                                            imageView.image = UIImage(named: "placeholder.jpg")
                                        }
                                    }
        )
    }
    
    //--------------------------------------
    // MARK: - Cache
    //--------------------------------------

    func clearAllCache() {
        self.clearDiskCache()
        self.clearMemoryCache()
        self.clearExpiredDiskCache()
    }
    
    func clearMemoryCache() {
        // Clear memory cache right away.
        self.cache.clearMemoryCache()
    }
    
    func clearDiskCache() {
        // Clear disk cache. This is an async operation.
        self.cache.clearDiskCache()
    }
    
    func clearExpiredDiskCache() {
        // Clean expired or size exceeded disk cache. This is an async operation.
        self.cache.cleanExpiredDiskCache()
    }
    
}
