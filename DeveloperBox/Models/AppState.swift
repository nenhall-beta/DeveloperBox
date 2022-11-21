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
    @Published var outputPath: String = "" {
        didSet {
            p_outputPath = outputPath
        }
    }
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
    @Published var selection: NavigationItem? = .codesign {
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
    let queue = DispatchQueue(label: "com.meitu.devbox.process")
    
    init() {
        inputPath = p_inputPath
        outputPath = p_outputPath
        templatePath = p_templatePath
        channelIDs = p_channelIDs
        identity = p_identity
    }

    func run(item: NavigationItem) {
        switch item {
        case .codesign:
            runCodesign()
        case .makeDMG:
            runCreateDMG(at: inputPath)
        case .resetApp:
            runClear()
        case .notary:
            break
        }
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
                        if self.needMakeDMG, let newPath = (result as? String) {
                            self.runCreateDMG(at: newPath)
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
            MakeDMG.run(appPath: inputPath, outputPath: self.outputPath, templateDir: self.templatePath) { info, error, exited, result in
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
