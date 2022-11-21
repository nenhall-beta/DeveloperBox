import Foundation

let version = "1.0.0"

public typealias HandleCallback = ((_ info: String?, _ error: String?, _ exited: Bool, _ result: Any) ->())

@discardableResult
func runProcess(from launchPath: String, arguments: [String]?, handle: @escaping HandleCallback) -> Any? {
    
    Log.info("执行路径：\(launchPath), 执行参数：\(String(describing: arguments))")
    
    handle("running...", nil, false, 1)
    
    let process = Process()
    let outPpipe = Pipe()
    process.standardOutput = outPpipe
    let errorPipe = Pipe()
    process.standardError = errorPipe
    process.launchPath = launchPath
    process.arguments = arguments
    process.launch()
    
    let errorData = errorPipe.fileHandleForReading.availableData
    if let errorString = String(data: errorData, encoding: .utf8), !errorString.isEmpty {
        Log.error("errorString:", errorString)
        handle(nil, errorString, false, -1)
        return errorString
    }
    
    let outData = outPpipe.fileHandleForReading.availableData
    if let outString = String(data: outData, encoding: .utf8), !outString.isEmpty {
        Log.info("outstring:", outString)
        handle(outString, nil, false, -1)
        return outString
    }
    process.terminationHandler = { p in
        handle("process termination.", nil, true, 1)
    }
    process.waitUntilExit()
    
    return nil
}
