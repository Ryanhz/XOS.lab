//
//  URLComponentsExtension.swift
//  FETools
//
//  Created by hzf on 2017/11/1.
//  Copyright © 2017年 hzf. All rights reserved.
//

import UIKit

extension URLComponents {
    /*
     let url = URLComponents(
     scheme: "https",
     host: "www.google.com",
     path: "/search",
     queryItems: [URLQueryItem(name: "q", value: "Formula One")]).url
     */
    init(scheme: String, host: String, path: String, queryItems: [URLQueryItem]) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
    
    
}
