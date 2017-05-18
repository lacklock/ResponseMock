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
            switch mock.contentType {
            case .json:
                guard let jsonData = try? JSONSerialization.data(withJSONObject: response) else {
                    return
                }
                responseData = jsonData
            case .plain:
                guard let stringResponse = response as? String else {
                    return
                }
                responseData = stringResponse.data(using: .utf8)
            case .file:
                guard let filePath = response as? String else {
                    return
                }
                let sourceURL = ResponseMockManager.resoureDirectory.appendingPathComponent(filePath)
                do {
                    responseData = try Data(contentsOf: sourceURL)
                }catch {
                    assertionFailure("read file failed")
                }
            }
        }else {
            assertionFailure("haven't specify response content")
            return
        }
        
        func response() {
            let urlResponse = HTTPURLResponse(url: request.url!, statusCode: mock.statusCode, httpVersion: nil, headerFields: mock.headers)
            client?.urlProtocol(self, didReceive: urlResponse!, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: responseData)
            client?.urlProtocolDidFinishLoading(self)
        }
        
        if let delay = mock.delay {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                response()
            })
        }else {
            response()
        }
    }
    
    
    override func stopLoading() {
    }
}

