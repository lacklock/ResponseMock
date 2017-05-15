//
//  ResponseMock.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/15.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import Foundation
import ObjectMapper

struct ResponseMock: Mappable {
    
    var url: String!
    var isWildcard = false
    var response: Any?
    var delay: Double?
    var headers: [String: Any]?
    
    init?(map: Map){}
    
    public mutating func mapping(map: Map) {
        url <- map["url"]
        response <- map["response"]
        delay <- map["delay"]
        headers <- map["headers"]
    }
}
