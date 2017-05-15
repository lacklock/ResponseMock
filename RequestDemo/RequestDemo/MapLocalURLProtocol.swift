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
        return true
    }
}
