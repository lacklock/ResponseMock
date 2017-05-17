//
//  MockConfig.swift
//  RequestDemo
//
//  Created by 卓同学 on 2017/5/15.
//  Copyright © 2017年 卓同学. All rights reserved.
//

import Foundation
import ObjectMapper

public class ResponseMockManager {
    
    /// start mock service
    ///
    /// - Parameters:
    ///   - inBackground: should load mock files asynchronous, defalut is **True** .
    ///   - loadMockFilesEachRequest: keep mock synchronize with local config files. should load mock files before each request happen, defalut is False.
    public static func start(inBackground: Bool = true, loadMockFilesEachRequest: Bool = false) {
        self.loadMockFilesEachRequest = loadMockFilesEachRequest
        if inBackground {
            DispatchQueue.global(qos: .userInitiated).async {
                loadConfig()
                URLProtocol.registerClass(MapLocalURLProtocol.self)
            }
        }else {
            loadConfig()
            URLProtocol.registerClass(MapLocalURLProtocol.self)
        }
    }
    
    public static var loadMockFilesEachRequest = false
    
    public static var rootPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("mock", isDirectory: true)
    static var resoureDirectory = rootPath.appendingPathComponent("resource", isDirectory: true)
    
    static var mocks = [ResponseMock]()
    
    static func loadConfig(){
        do {
            mocks.removeAll()
            let configFiles = try FileManager.default.contentsOfDirectory(at: rootPath, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            for configFile in configFiles {
                if #available(iOS 9.0, *) {
                    guard configFile.hasDirectoryPath == false else {
                        return
                    }
                } else {
                   let isDirectory = (try? configFile.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
                    guard isDirectory == false else {
                        return
                    }
                }
                guard let configData = try? Data(contentsOf: configFile) else {
                    assertionFailure("can't read file")
                    continue
                }
                do {
                    let jsons = try JSONSerialization.jsonObject(with: configData, options: []) as? [[String: Any]]
                    guard let jsonDicts = jsons else {
                        assertionFailure("mock json should be array, [[String: Any]]")
                        continue
                    }
                    for config in jsonDicts {
                        guard checkConfigFileIsVaild(config: config) else { continue }
                        if let mock = ResponseMock(JSON: config) {
                            mocks.append(mock)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
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
        guard config.keys.contains("url")else {
            return false
        }
        guard config.keys.contains("response")||config.keys.contains("resource") else {
            return false
        }
        return true
    }
    
    static func isMockFor(request: URLRequest) -> ResponseMock? {
        return mocks.first(where: { $0.isMatch(request) })
    }
}
