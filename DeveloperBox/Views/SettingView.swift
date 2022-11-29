//
//  SettingView.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/11/28.
//

import SwiftUI

struct SettingView: View {
    @Binding var setting: Bool
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack(alignment: .top) {
            Color(NSColor.windowBackgroundColor)
                .cornerRadius(8)
            HStack(alignment: .top) {
                Text("默认输出目录：")
                Text(appState.workDirectory)
                Button("更改输入路径") {
                    if let url = Panel.showSave(directoryPath: appState.workDirectory) {
                        appState.workDirectory = url.path
                    }
                }
                Button("重置") {
                    appState.resetWorkDirectory()
                }
            }
            .padding(20)

        }
        .frame(minWidth: DBX.Window.minSize.width,
               maxWidth: .infinity,
               minHeight: DBX.Window.minSize.height,
               maxHeight: .infinity,
               alignment: .center)
        .onTapGesture {
            setting.toggle()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(setting: Binding.constant(false))
    }
}
