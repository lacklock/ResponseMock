//
//  MapLocalURLProtocol.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/15.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import UIKit

class MapLocalURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        if let url = request.url {
            if let _ = ResponseMockManager.isMockFor(url: url){
                return true
            }
        }
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
        
    override func startLoading() {
        guard let url = request.url else {
            return
        }
        guard let mock = ResponseMockManager.isMockFor(url: url) else {
            return
        }
        guard let response = mock.response  else {
            return
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: response) else {
            return
        }
        client?.urlProtocol(self, didLoad: jsonData)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}

