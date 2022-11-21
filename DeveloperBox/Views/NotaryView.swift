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
                TextField("请选择DMG模版文件路径", text: $appState.templatePath)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(8)
                Button {
                    if let url = Panel.showOpen(fileTypes: ["dmgCanvas"])?.first {
                        appState.templatePath = url.path
                    }
                } label: {
                    Text("输入文件")
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
            }
            
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
        .padding(20)
    }
}

struct NotaryView_Previews: PreviewProvider {
    static var previews: some View {
        NotaryView()
            .environmentObject(AppState())
    }
}
