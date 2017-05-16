//
//  ResponseMock.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/15.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import Foundation
import ObjectMapper

let URLTransofrm = TransformOf<URL,String>(fromJSON: { (value: String?) -> URL? in
    if let urlString = value {
        return URL(string: urlString)
    }
    return nil
}, toJSON: { (value: URL?) -> String? in
    return nil
})

struct ResponseMock: Mappable {
    
    var url: URL?
    var isWildcard = false
    var response: Any?
    var delay: Double?
    var headers: [String: Any]?
    
    init?(map: Map){
        let urlString = map.JSON["url"] as! String
        if URL(string: urlString) == nil {
            assertionFailure("\(urlString) is invalid url")
            return nil
        }
    }
    
    public mutating func mapping(map: Map) {
        url <- (map["url"],URLTransofrm)
        response <- map["response"]
        delay <- map["delay"]
        headers <- map["headers"]
    }
}

extension ResponseMock {
    
    func isMatch(_ targetURL: URL) -> Bool {
        guard let mockURL = url else {
            return false
        }
        guard mockURL.host == targetURL.host else {
            return false
        }
        guard mockURL.pathComponents == targetURL.pathComponents else {
            return false
        }
        return true
    }
}
