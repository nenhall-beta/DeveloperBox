//
//  Codesign.swift
//  
//
//  Created by meitu@nenhall on 2022/9/30.
//

import Cocoa

public struct Codesign {
    
    public static func run(appPath: String, identity: String, updateKeyValues: [String: String]? = nil, handle: @escaping HandleCallback) {
        do {
            guard FileManager.default.fileExists(atPath: appPath) else {
                handle(nil, "file does not Exists", true, -1)
                return
            }
            let contentsPath = appPath.appending("/Contents")
            let originalPlistPath = contentsPath.appending("/Info.plist")
            let entitlementsPath = contentsPath.appending("/embedded.provisionprofile")
            guard FileManager.default.fileExists(atPath: contentsPath),
                  FileManager.default.fileExists(atPath: originalPlistPath) else {
                handle(nil, "contents file does not Exists", true, -1)
                return
            }
            guard let originalInfoPlistDict = NSMutableDictionary(contentsOfFile: originalPlistPath) else {
                handle(nil, "info plist file does not Exists", true, -1)
                return
            }
            guard let range = appPath.range(of: ".\(URL(fileURLWithPath: appPath).pathExtension)") else {
                handle(nil, "app file does not Exists", true, -1)
                return
            }
            
            var newPaths: [String] = []
            if let updateKeyValues = updateKeyValues {
                for (key, value) in updateKeyValues {
                    var tempPath = appPath
                    tempPath.insert(contentsOf: "-\(value)", at: range.lowerBound)
                    let newPlistPath = tempPath.appending("/Contents/Info.plist")
                    try FileManager.default.copyItem(atPath: appPath, toPath: tempPath)
                    newPaths.append(tempPath)
                    originalInfoPlistDict[key] = value
                    originalInfoPlistDict.write(toFile: newPlistPath, atomically: true)
                    /// 签名
                    var arguments = ["-f", "-s", "\(identity)", "\(tempPath)"]
                    if FileManager.default.fileExists(atPath: entitlementsPath) {
                        arguments.append(" --entitlements \(entitlementsPath)")
                    }
                    runProcess(from: "/usr/bin/codesign", arguments: arguments) { info, error, exited, result in
                        Log.info("完成单个签名：", tempPath)
                        if exited {
                            handle(info, error, exited, tempPath)
                        } else {
                            handle(info, error, exited, result)
                        }
                    }
                }
            }
        } catch {
            Log.error(error.localizedDescription)
            handle(nil, error.localizedDescription, true, -1)
        }
    }
    
    public static func findIdentity() -> [String]? {
        let identity = runProcess(from: "/usr/bin/security", arguments: ["find-identity", "-v", "-p", "codesigning"]) { _, _, _, _ in
        } as? String
        var filterIdentitys: [String] = []
        if let identitys = identity?.components(separatedBy: "\n") {
            for item in identitys {
                let ids = item.components(separatedBy: "\"")
                if ids.count == 3 {
                    filterIdentitys.append(ids[1])
                }
            }
        }
        return filterIdentitys
    }
    
}
