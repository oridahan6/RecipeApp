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
    
    private var cache: ImageCache
    
    private init() {
        self.cache = KingfisherManager.sharedManager.cache
    }
    
    //--------------------------------------
    // MARK: - Images
    //--------------------------------------
    func setImageWithUrl(imageView: UIImageView, url: String) {
        imageView.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: UIImage(named: "placeholder.jpg"))
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
