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
    var method: HTTPMethod = .get
    
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
        method <- map["method"]
    }
}

extension ResponseMock {
    
    func isMatch(_ request: URLRequest) -> Bool {
        guard let targetURL = request.url,
              let mockURL = url else {
                return false
        }
        guard mockURL.host == targetURL.host else {
            return false
        }
        guard method.rawValue == request.httpMethod else {
                return false
        }
        guard mockURL.pathComponents == targetURL.pathComponents else {
            return false
        }
        guard isParamtersMatch(request: request) else {
            return false
        }
        return true
    }
    
    private func isParamtersMatch(request: URLRequest) -> Bool {
        guard let targetURL = request.url,
            let mockURL = url else {
            return false
        }
        if mockURL.query != nil {
            guard targetURL.query != nil else {
                return false
            }
            guard let mockComponents = URLComponents(url: mockURL, resolvingAgainstBaseURL: false)?.queryItems,
                let targetComponents = URLComponents(url: targetURL, resolvingAgainstBaseURL: false)?.queryItems else {
                    return false
            }
            for mockQuery in mockComponents {
                guard let targetQuery = targetComponents.first(where: {
                    $0.name == mockQuery.name
                })else {
                    return false
                }
                guard mockQuery.value == targetQuery.value else {
                    return false
                }
            }
        }
        if method != .get { // TODO:  check body parameter
            
        }
        return true
    }
}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
