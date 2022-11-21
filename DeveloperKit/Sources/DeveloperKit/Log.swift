//
//  Log.swift
//  AirBrushStudio
//
//  Created by meitu@nenhall on 2022/8/27.
//

import Foundation
import SwiftyBeaver

public enum Log {

    /// 记录一些通常不重要的东西 (lowest)
    public static func verbose(_ items: Any?..., separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.verbose(items.toString(separator), file, function, line: line)
    }

    /// 记录有助于调试的内容 (low)
    public static func debug(_ items: Any?..., separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.debug(items.toString(separator), file, function, line: line)
    }

    /// 记录您真正感兴趣但不是问题或错误的内容 (normal)
    public static func info(_ items: Any?..., separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.info(items.toString(separator), file, function, line: line)
    }

    /// 记录可能引起麻烦的警告内容 (high)
    public static func warning(_ items: Any?..., separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.warning(items.toString(separator), file, function, line: line)
    }

    /// 记录一些会让你在晚上保持清醒的内容 (highest)
    public static func error(_ items: Any?..., separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.error(items.toString(separator), file, function, line: line)
        // do something eg.: upload error
    }
}

private extension Log {

    static var log: SwiftyBeaver.Type = {
        #if DEBUG
        let destinations: [BaseDestination] = [file, console]
        #else
        let destinations: [BaseDestination] = [file]
        #endif
        destinations.forEach { SwiftyBeaver.addDestination($0) }
        return SwiftyBeaver.self
    }()

    static var console: ConsoleDestination = {
        let dest = ConsoleDestination()
        dest.asynchronously = false
        dest.levelString.verbose = "👵🏻"// VERBOSE"
        dest.levelString.debug   = "🐛"// DEBUG"
        dest.levelString.info    = "ℹ️"// INFO"
        dest.levelString.warning = "⚠️"// WARNING"
        dest.levelString.error   = "❌"// ERROR"
        dest.format = "$DHH:mm:ss.SSS$d $L [$N:$l → $F] $M"
        dest.minLevel = .debug
        return dest
    }()
    static var file: FileDestination = {
        let dest = FileDestination()
        dest.asynchronously = true
//        dest.logFileURL = Log.fileURL
        print("LogFileURL:", dest.logFileURL as Any)
        dest.levelColor.verbose = "246m"
        dest.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c [$N:$l → $F] $M"
        return dest
    }()
}

private extension Array where Element == Any? {

    func toString(_ separator: String = " ") -> String {
        return map {
            guard let element = $0 else { return "nil" }
            return String(describing: element)
        }.joined(separator: separator)
    }
}
