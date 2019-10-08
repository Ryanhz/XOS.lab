//
//  FENetworkCache.swift
//  FETools
//
//  Created by hzf on 2017/11/2.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit
import Cache

class ZymeNetworkCache {
    
    private static let _shared = ZymeNetworkCache()
    
    static var shared: ZymeNetworkCache? {
        
       
        return _shared
    }
    
    static let kZymeNetworkResponseCache = "kZymeNetworkResponseCache"
    
    var diskConfig: DiskConfig
    
    var memoryConfig: MemoryConfig
    
    var storage: Storage<Data>
    
    private init() {
        
        diskConfig = DiskConfig(
            // The name of disk storage, this will be used as folder name within directory
            name: "kZymeNetworkResponseCache",
            // Expiry date that will be applied by default for every added object
            // if it's not overridden in the `setObject(forKey:expiry:)` method
            expiry: .date(Date().addingTimeInterval(2*3600)),
            // Maximum size of the disk cache storage (in bytes)
            maxSize: 10000,
            // Where to store the disk cache. If nil, it is placed in `cachesDirectory` directory.
            directory: try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                    appropriateFor: nil, create: true).appendingPathComponent("MyPreferences"),
            // Data protection is used to store files in an encrypted format on disk and to decrypt them on demand
            protectionType: .complete
        )
        
        memoryConfig = MemoryConfig(
            // Expiry date that will be applied by default for every added object
            // if it's not overridden in the `setObject(forKey:expiry:)` method
            expiry: .date(Date().addingTimeInterval(2*60)),
            /// The maximum number of objects in memory the cache should hold
            countLimit: 50,
            /// The maximum total cost that the cache can hold before it starts evicting objects
            totalCostLimit: 0
        )
        
        storage = try! Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forData())
    }
    
//    var getAllHttpCacheSize: Int {
//        return   0
//    }
    
    func setHttpCache<U: Codable>(data: U, key: String) {
        let uStorage = storage.transformCodable(ofType: U.self)
        try? uStorage.setObject(data, forKey: key)
    }
    
    func setHttpCache<U: Codable>(data: U, key: String, expiry: Expiry?) {
        let uStorage = storage.transformCodable(ofType: U.self)
        try? uStorage.setObject(data, forKey: key,expiry: expiry)
    }

    func httpCacheFor<U: Codable>(key: String) -> U?{
        let uStorage = storage.transformCodable(ofType: U.self)
        return try? uStorage.object(forKey: key)
    }
    
    func cacheEntry<U: Codable>(key: String)->Entry<U>?{
        let uStorage = storage.transformCodable(ofType: U.self)
        return try? uStorage.entry(forKey: key)
    }
    
    func removeHttpCache(key: String) {
        try? storage.removeObject(forKey: key)
    }
    
    func removeExpire(){
        try? storage.removeExpiredObjects()
    }
    
    func removeAllHttpCache(){
        try? storage.removeAll()
    }
}
