//
//  MockConfig.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/15.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ResponseMockManager {
    
    public static func start(inBackground: Bool = true) {
        URLProtocol.registerClass(MapLocalURLProtocol.self)
        if inBackground {
            DispatchQueue.global(qos: .userInitiated).async {
                loadConfig()
            }
        }else {
            loadConfig()
        }
    }
    
    public static var configUpdateEachRequest = false
    
    public static var rootPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ResponseMock", isDirectory: true)
    
    static var mocks = [ResponseMock]()
    
    static func loadConfig(){
        do {
            let configFiles = try FileManager.default.contentsOfDirectory(at: rootPath, includingPropertiesForKeys: nil)
            for configFile in configFiles {
                guard let configData = try? Data(contentsOf: configFile) else {
                    assertionFailure("can't read file")
                    continue
                }
                guard let jsonDict = try? JSONSerialization.jsonObject(with: configData, options: .mutableLeaves) as? [String: Any] else { return }
                guard let config = jsonDict else {
                    continue
                }
                guard checkConfigFileIsVaild(config: config) else { continue }
                if let mock = ResponseMock(JSON: config) {
                    mocks.append(mock)
                }
            }
        } catch {
            print("config folder not found")
        }
    }
    
    private static func checkConfigFileIsVaild(config: [String: Any]) -> Bool {
        if config["enable"] as? Bool == false {
            return false
        }
        guard config.keys.contains("url"),
            config.keys.contains("response") else {
            return false
        }
        return true
    }
}
