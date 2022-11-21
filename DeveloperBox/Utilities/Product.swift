//
//  Product.swift
//  AirBrushStudio
//
//  Created by meitu@nenhall on 2022/8/27.
//

import Cocoa
import DeveloperKit

enum DBX {}

extension DBX {
    
    /// 产品相关信息，结构体
    struct Product {
        private init() {}
    }
    
    /// 链接器：在外部浏览器打开某网页
    struct Linker {
        private init() {}
    }
}

extension DBX {
    
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}

extension DBX {
    
    enum Key {
        static let `return` = "\r"
        static let esc = "\u{1b}" // ESC
    }
}

extension DBX {
    
    /// 黄金比例: (√5 - 1) / 2 ≈ 0.618
    static let goldenRatio: CGFloat = (sqrt(5) - 1) / 2
    
    enum Window {
        /// 窗口默认最小尺寸
        static let minSize = NSSize(width: 960, height: 612)
        
        /// 窗口默认尺寸
        static let defaultSize: NSSize = {
            let height: CGFloat = 760
            let size = NSSize(width: height / DBX.goldenRatio, height: height)
            return size
        }()
    }
}

extension DBX.Product {

    static let displayName = infoDict[kCFBundleNameKey as String] as? String ?? ""
    static let bundleID = Bundle.main.bundleIdentifier ?? ""
    static let supportURL: URL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    static let appSupportURL: URL = supportURL.appendingPathComponent(bundleID)
    static var temporaryDirectory: URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory().appending("/com.nenhall.deleloperbox"))
        guard !FileManager.default.fileExists(atPath: url.path) else { return url }
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            Log.error("create temporaryDirectory:", error.localizedDescription)
        }
        return url
    }
}

extension DBX.Product {
    
    static let languageID: String? = Bundle.main.localizedInfoDictionary?["langID"] as? String
}

/// 定义产品销售渠道
enum ProductChanel: Equatable {
    case web
    case appStore
    
    var isAppStore: Bool {
        if case .appStore = self {
            return true
        }
        return false
    }
}

extension DBX.Product {
    
    private static let infoDict: [String: Any] = Bundle.main.infoDictionary!
    static let version = (infoDict["CFBundleShortVersionString"]) as? String ?? ""
    static let buildVersion = (infoDict[kCFBundleVersionKey as String]) as? String ?? ""
}

extension DBX {
    
    // 是否是首次启动 重装后返回没有启动过
    static func isLaunchedBefore() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "isLaunchedBefore")
        if launchedBefore {
            return true
        } else {
            UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
            return false
        }
    }

    // 判断应用是否是第一次启动和版本升级过
    static func isFirstLaunchOrUpdate() -> Bool {
        // 获取上次启动应用保存的appVersion
        let version = "\(UserDefaults.standard.object(forKey: "kAppVersion") ?? "")"
        let currentVersion = Self.Product.version
        // 版本升级或者首次登陆
        if version != currentVersion {
            UserDefaults.standard.setValue(Self.Product.version, forKey: "kAppVersion")
            return true
        } else {
            return false
        }
    }
}

extension DBX.Linker {
    
    enum WebURLType: String {
        case login, buy, signup, termsOfService, privacyPolicy, faq
    }
    
    @discardableResult
    static func openLinkAtBrowse(with urlString: String) -> Bool {
        guard !urlString.isEmpty, let url = URL(string: urlString) else {
            return false
        }
        return NSWorkspace.shared.open(url)
    }
}

