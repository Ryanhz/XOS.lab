//
//  FENetworkCache.swift
//  FETools
//
//  Created by hzf on 2017/11/2.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit
import YYCache

class HzyNetworkCache {
    
    private static let _shared = HzyNetworkCache()
    
    static var shared: HzyNetworkCache? {
        
        if _shared.dataCache == nil {
            
            guard let cache = YYCache(name: kHzyNetworkResponseCache) else {
                return nil
            }
            _shared.dataCache = cache
        }
        return _shared
    }
    
    static let kHzyNetworkResponseCache = "kHzyNetworkResponseCache"
    
    private var dataCache: YYCache!
    
    private init() {}
    
    var getAllHttpCacheSize: Int {
        return dataCache?.diskCache.totalCost() ?? 0
    }
    
    func setHttpCache(data: NSCoding?, cacheKey: String) {
        dataCache.setObject(data , forKey: cacheKey)
    }

    func httpCacheFor(cacheKey: String) -> NSCoding?{
        return dataCache.object(forKey: cacheKey)
    }
    
    func removeHttpCache(cacheKey: String) {
        dataCache.removeObject(forKey: cacheKey)
    }
    
    func removeAllHttpCache(){
        dataCache.diskCache.removeAllObjects()
    }
}
