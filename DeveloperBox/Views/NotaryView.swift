//
//  NotaryView.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/11/21.
//

import Foundation
import SwiftUI

struct NotaryView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("应用专用密码:")
                TextField(appState.appSpecialKey, text: $appState.appSpecialKey)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(8)
            }
            
            HStack {
                Text("Apple ID:")
                TextField(appState.appleID, text: $appState.appleID)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(8)
            }
            
            HStack {
                Text("Team ID:")
                TextField(appState.teamID, text: $appState.teamID)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(8)
            }
            
            HStack {
                TextField("选择要公证的应用程序压缩文件", text: $appState.notrayFilePath)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(8)
                Button {
                    if let url = Panel.showOpen(fileTypes: ["zip", "dmg"])?.first {
                        appState.notrayFilePath = url.path
                    }
                } label: {
                    Text("选择")
                        .bold()
                }
            }
            
            HStack {
                Text("公证结果编号：\(appState.notaryCode)")
                Button {
                    if !appState.notaryCode.isEmpty {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString("\(appState.notaryCode)", forType: .string)
                    }
                } label: {
                    Text("复制")
                        .bold()
                }
                Spacer()
                Toggle("把以上信息保存到钥匙串", isOn: $appState.saveKey)
            }

            ZStack(alignment: .topLeading) {
                TextEditor(text: .constant(appState.outputLogString))
                    .lineSpacing(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                if appState.outputLogString.isEmpty {
                    Text("操作日志...")
                        .padding(10)
                }
            }
        }
        .padding(20)
    }
}

struct NotaryView_Previews: PreviewProvider {
    static var previews: some View {
        NotaryView()
            .environmentObject(AppState())
    }
}
