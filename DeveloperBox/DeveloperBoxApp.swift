//
//  DeveloperBoxApp.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/9/30.
//

import SwiftUI
import DeveloperKit

@main
struct DeveloperBoxApp: App {
    @AppStorage("displayMode") var displayMode = DisplayMode.auto

    var body: some Scene {
        WindowGroup {
            MainView()
                .frame(minWidth: DBX.Window.minSize.width,
                       maxWidth: .infinity,
                       minHeight: DBX.Window.minSize.height,
                       maxHeight: .infinity,
                       alignment: .center)
//                .onAppear {
//                  DisplayMode.changeDisplayMode(to: displayMode)
//                }
                .onChange(of: displayMode) { newValue in
                  DisplayMode.changeDisplayMode(to: newValue)
                }
        }
        .commands {
            Menus()
        }
    }
}
