//
//  Helper.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/10/8.
//

import Foundation
import DeveloperKit
import SwiftUI

class AppState: ObservableObject {
    
    static let shared = AppState()

    private var ableRun: Bool = true
    private var loginfo: [String: String] = [:]
    @AppStorage("inputPath") private var p_inputPath = ""
    @Published var inputPath: String = "" {
        didSet {
            p_inputPath = inputPath
        }
    }
    @AppStorage("templatePath") private var p_templatePath: String = ""
    @Published var templatePath: String = "" {
        didSet {
            p_templatePath = templatePath
        }
    }
    @AppStorage("outputPath") private var p_outputPath: String = ""
    @AppStorage("channelIDs") private var p_channelIDs: String = ""
    @Published var channelIDs: String = "" {
        didSet {
            p_channelIDs = channelIDs
        }
    }
    @AppStorage("identity") private var p_identity: String = ""
    @Published var identity: String = "" {
        didSet {
            p_identity = identity
        }
    }
    @Published var outputLogString: String = ""
    @Published var cleanLog: Bool = false {
        didSet {
            guard cleanLog, let selection = selection else { return }
            loginfo[selection.rawValue] = ""
            outputLogString = ""
        }
    }
    @Published var selection: NavigationItem? = .notarizate {
        didSet {
            guard let selection = selection else { return }
            outputLogString = loginfo[selection.rawValue] ?? ""
        }
    }
    @Published var processing: Bool = false {
        didSet {
            if let selection = selection, processing, ableRun {
                run(item: selection)
            }
        }
    }
    @Published var needMakeDMG: Bool = false
    @Published var needNotarizate: Bool = false
    @Published var notaryCode = ""
    @Published var notrayFilePath = ""
    @AppStorage("appleID") var appleID = ""
    @AppStorage("teamID") var teamID = "5V292QZ538"
    @AppStorage("appPassword") var appSpecialKey = ""
    @AppStorage("saveKey") var saveKey = false
    @AppStorage("webhook") var webhook = ""
    @AppStorage("webhook") var workDirectory: String = {
        var decktop = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first ?? NSHomeDirectory() + "/\(NSUserName())/Desktop"
        decktop.append("/DeveloperBox")
        return decktop
    }()

    let queue = DispatchQueue(label: "com.meitu.devbox.process")
    
    private init() {
        if !FileManager.default.fileExists(atPath: workDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: workDirectory, withIntermediateDirectories: true)
            } catch {
                Log.error(error.localizedDescription)
                updateLog(error.localizedDescription)
            }
        }
        inputPath = p_inputPath
        templatePath = p_templatePath
        channelIDs = p_channelIDs
        identity = p_identity
    }
    
    func resetWorkDirectory() {
        let decktop = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first ?? NSHomeDirectory() + "/\(NSUserName())/Desktop"
        workDirectory = decktop + "/DeveloperBox"
        if !FileManager.default.fileExists(atPath: workDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: workDirectory, withIntermediateDirectories: true)
            } catch {
                Log.error(error.localizedDescription)
                updateLog(error.localizedDescription)
            }
        }
    }

    func run(item: NavigationItem) {
        switch item {
        case .codesign:
            runCodesign()
        case .makeDMG:
            runCreateDMG(at: inputPath)
        case .resetApp:
            runClear()
        case .notarizate:
            runNotarizate()
        }
    }
    
    func runNotarizate() {
        updateLog("开始公证")
        
        do {
            try URL(fileURLWithPath: "/Users/meitu/Desktop/Fruta.app").zip(dest: URL(fileURLWithPath: "/Users/meitu/Desktop/Fruta2.zip"))
        } catch {
            Log.error(error.localizedDescription)
        }
        Notarizate.uploadFile(notrayFilePath, teamID: teamID, appleID: appleID, appKey: appSpecialKey, callHandle: { notaryCode in
            guard let notaryCode = notaryCode else { return }
            if !notaryCode.isEmpty {
                self.notaryCode = notaryCode
                self.updateLog(notaryCode)
//                Notarizate.injectCode(appPath: self.inputPath)
            }
        })
    }
    
    func runCodesign() {
        let tempPath = inputPath
        guard !inputPath.isEmpty else {
            updateLog("文件路径不能为空")
            processing = false
            return
        }
        let chennels = channelIDs.components(separatedBy: ",")
        queue.async { [weak self] in
            guard let self = self else { return }
            for item in chennels {
                Codesign.run(appPath: tempPath, identity: self.identity, updateKeyValues: ["chennel": item]) { info, error, exited, result in
                    DispatchQueue.main.async {
                        if self.needMakeDMG, let _ = (result as? String) {
                            self.runCreateDMG(at: self.workDirectory)
                        }
                        self.updateLog((info ?? error) ?? "")
                        self.ableRun = false
                        self.processing = !exited
                        self.ableRun = true
                    }
                }
            }
        }
    }
    
    func runCreateDMG(at inputPath: String) {
        queue.async { [weak self] in
            guard let self = self else { return }
            MakeDMG.run(appPath: inputPath, outputPath: self.workDirectory, templateDir: self.templatePath) { info, error, exited, result in
                DispatchQueue.main.async {
                    self.updateLog((info ?? error) ?? "")
                    self.ableRun = false
                    self.processing = !exited
                    self.ableRun = true
                }
            }
        }
    }
    
    func runClear() {
     
    }
    
    func findIdentity() -> [String] {
        Codesign.findIdentity() ?? []
    }
    
    private func updateLog(_ info: String) {
        guard let selection = self.selection else { return }
        var oldLog = loginfo[selection.rawValue] ?? ""
        oldLog.append(info)
        oldLog.append("\n")
        loginfo[selection.rawValue] = oldLog
        outputLogString = oldLog
    }
}
