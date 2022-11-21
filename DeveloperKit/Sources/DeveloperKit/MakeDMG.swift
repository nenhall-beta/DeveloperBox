//
//  MakeDMG.swift
//  
//
//  Created by meitu@nenhall on 2022/10/8.
//

import Foundation

public struct MakeDMG {
    
    public static func run(appPath: String, outputPath: String, templateDir: String, handle: @escaping HandleCallback) {
        var arguments: [String] = []
        if !appPath.isEmpty {
            arguments.append("-i")
            arguments.append(appPath)
        }
        if !outputPath.isEmpty {
            arguments.append("-o")
            arguments.append(outputPath)
        }
        if !templateDir.isEmpty {
            arguments.append("-t")
            arguments.append(templateDir)
        }
        
        guard let shellPath = Bundle.main.resourcePath?.appending("/DeveloperKit_DeveloperKit.bundle/Contents/Resources/shell/create_dmg.py") else {
            Log.error("找不到脚本文件")
            return
        }
        arguments.insert(shellPath, at: 0)
        
        runProcess(from: "/usr/local/Cellar/python@3.9/3.9.13_4/bin/python3.9", arguments: arguments, handle: handle)
    }
}
