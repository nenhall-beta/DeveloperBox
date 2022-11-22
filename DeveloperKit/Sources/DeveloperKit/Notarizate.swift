//
//  Notarizate.swift
//  
//
//  Created by meitu@nenhall on 2022/11/21.
//

import Foundation

/// 专用密钥： https://support.apple.com/en-us/HT204397
public struct Notarizate {
    
    private static let keychainName = "App Notay Key"
    
    public static func uploadFile(_ path: String, teamID: String, appleID: String, appKey: String, webhook: String = "", callHandle: @escaping (_ notaryCode: String?) ->()) {
        
        saveKeyToKeychain(teamID: teamID, appleID: appleID, appKey: appKey)
        
        let arguments = [
            "notarytool",
            "submit", path,
            "--keychain-profile", Self.keychainName,
            "--wait",
            "--webhook", webhook
        ]
        
        DeveloperKit.runProcess(from: "/usr/bin/xcrun", arguments: arguments) { info, error, exited, result in
            callHandle(info)
        }
    }
    
    public static func saveKeyToKeychain(teamID: String, appleID: String, appKey: String, keyName: String = "") {
        let keychainName = keyName.isEmpty ? Self.keychainName : keyName
        
        let arguments = [
            "notarytool",
            "store-credentials", keychainName,
            "--apple-id",  appleID,
            "--team-id", teamID,
            "--password", appKey
        ]
        DeveloperKit.runProcess(from: "/usr/bin/xcrun", arguments: arguments) { info, error, exited, result in
            
        }
        // xcrun notarytool store-credentials "Developer ID2" --apple-id "nenghao.wu@pixocial.com" --team-id "5V292QZ538" --password "tnlm-paco-xhot-pudk"
    }
    
    public static func injectCode(appPath: String) {
        let arguments = [
            "stapler",
            "staple",
            appPath
        ]
        DeveloperKit.runProcess(from: "/usr/bin/xcrun", arguments: arguments) { info, error, exited, result in
            
        }
    }
}
