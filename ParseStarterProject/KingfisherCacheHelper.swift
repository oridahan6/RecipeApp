//
//  CacheHelper.swift
//  Recipes
//
//  Created by Ori Dahan on 06/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Kingfisher

class KingfisherCacheHelper {

    static let sharedInstance = KingfisherCacheHelper()
    
    private var cache: ImageCache
    
    private init() {
        self.cache = KingfisherManager.sharedManager.cache
    }
    
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
