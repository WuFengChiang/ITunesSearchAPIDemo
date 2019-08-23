//
//  ITunesSearchAPIHelper.swift
//  M800Assignment
//
//  Created by wuufone on 2019/8/23.
//  Copyright © 2019 江武峯. All rights reserved.
//

import UIKit

class ITunesSearchAPIHelper: NSObject {
    
    public func url(queryItems: [URLQueryItem]) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
    public func queryItems(term: String) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "country", value: "tw")
        ]
    }
    
    public func search(term: String, handler: (Array<Dictionary<String, AnyObject>>) -> Void) {
        do {
            let responseData = try Data(contentsOf: url(queryItems: queryItems(term: term)))
            let responseJSONObject = try JSONSerialization.jsonObject(
                with: responseData,
                options: .allowFragments) as! Dictionary<String, AnyObject>
            for item in responseJSONObject {
                if item.key == "results" {
                    handler(item.value as! Array<Dictionary<String, AnyObject>>)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
