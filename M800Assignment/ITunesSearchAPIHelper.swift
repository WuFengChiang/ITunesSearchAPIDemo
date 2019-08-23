//
//  ITunesSearchAPIHelper.swift
//  M800Assignment
//
//  Created by wuufone on 2019/8/23.
//  Copyright © 2019 江武峯. All rights reserved.
//

import UIKit

class ITunesSearchAPIHelper: NSObject {
    
    public static func url(queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
    public static func queryItems(term: String) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "country", value: "tw")
        ]
    }
}
