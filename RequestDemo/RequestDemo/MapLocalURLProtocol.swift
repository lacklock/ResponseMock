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
        if request.url != nil {
            if let _ = ResponseMockManager.isMockFor(request: request){
                return true
            }
        }
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
        
    override func startLoading() {
        guard request.url != nil else {
            return
        }
        guard let mock = ResponseMockManager.isMockFor(request: request) else {
            return
        }
        guard let response = mock.response  else {
            return
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: response) else {
            return
        }
        if let delay = mock.delay {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                self.client?.urlProtocol(self, didLoad: jsonData)
                self.client?.urlProtocolDidFinishLoading(self)
            })
        }else {
            client?.urlProtocol(self, didLoad: jsonData)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        
    }
}

