//
//  File.swift
//  
//
//  Created by meitu@nenhall on 2022/11/22.
//

import Foundation

public extension URL {

    func zip(dest: URL? = nil) throws -> URL {

        let destURL = dest ?? appendingPathExtension("zip")

        let fm = FileManager.default
        var isDir: ObjCBool = false

        let srcDir: URL
        let srcDirIsTemporary: Bool
        if !path.isEmpty && fm.fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue == true {
            srcDir = self
            srcDirIsTemporary = false
        } else {
            srcDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
            try fm.createDirectory(at: srcDir, withIntermediateDirectories: true, attributes: nil)
            let tmpURL = srcDir.appendingPathComponent(lastPathComponent)
            try fm.copyItem(at: self, to: tmpURL)
            srcDirIsTemporary = true
        }

        let coord = NSFileCoordinator()
        var error: NSError?

        coord.coordinate(readingItemAt: srcDir, options: .forUploading, error: &error) { url1 in
            Log.info(url1)
            do {
                try fm.copyItem(at: url1, to: destURL)
            } catch let coordErro {
                Log.error(coordErro)
            }
        }

        if srcDirIsTemporary { try fm.removeItem(at: srcDir) }
        if let error = error { throw error }
        return destURL
    }
}

public extension Data {

    func zip() throws -> Data {
        let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
        try self.write(to: tmpURL, options: .atomic)
        let zipURL = try tmpURL.zip()
        let fm = FileManager.default
        let zippedData = try Data(contentsOf: zipURL, options: .alwaysMapped)
        try fm.removeItem(at: tmpURL) // clean up
        try fm.removeItem(at: zipURL)
        return zippedData
    }
}
