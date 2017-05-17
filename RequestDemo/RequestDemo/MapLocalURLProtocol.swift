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
            if ResponseMockManager.loadMockFilesEachRequest {
                ResponseMockManager.loadConfig()
            }
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
        guard let mock = ResponseMockManager.isMockFor(request: request) else {
            return
        }
        var responseData: Data!
        if let response = mock.response {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: response) else {
                return
            }
            responseData = jsonData
        }else if let resource = mock.resource {
            let sourceURL = ResponseMockManager.resoureDirectory.appendingPathComponent(resource)
            do {
               responseData = try Data(contentsOf: sourceURL)
            }catch {
                assertionFailure("read file failed")
            }
        }else {
            return
        }
        if let delay = mock.delay {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                self.client?.urlProtocol(self, didLoad: responseData)
                self.client?.urlProtocolDidFinishLoading(self)
            })
        }else {
            client?.urlProtocol(self, didLoad: responseData)
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
    }
}

