//
//  MakeDMGView.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/9/30.
//

import SwiftUI

struct MakeDMGView: View {
    @State var openPanel = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("请选择一个 app 格式文件", text: $appState.inputPath)
                        .multilineTextAlignment(.leading)
                        .cornerRadius(8)
                    Button {
                        if let url = Panel.showOpen(fileTypes: [.applicationBundle, .folder])?.first {
                            appState.inputPath = url.path
                        }
                    } label: {
                        Text("输入文件")
                            .bold()
                    }
                }
                .padding([.top, .bottom], 20)
                
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
                .padding(.bottom, 20)
                
                HStack {
                    Text("导出路径（可在设置中更改）:")
                        .multilineTextAlignment(.leading)
                        .cornerRadius(8)
                        .padding(5)
                    Text(appState.workDirectory)
                        .multilineTextAlignment(.leading)
                        .cornerRadius(8)
                    
                    Spacer()
                }
                .padding(.bottom, 20)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: .constant(appState.outputLogString))
                        .lineSpacing(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    if appState.outputLogString.isEmpty {
                        Text("操作日志...")
                            .padding(10)
                    }
                }
                .font(.system(size: 12))
                .foregroundColor(.primary)

            }
            .padding(10)
        }
        .navigationTitle("制作 DMG 镜像")
    }
}

struct MakeDMGView_Previews: PreviewProvider {
    @State private static var processing = false

    static var previews: some View {
        MakeDMGView()
            .environmentObject(AppState.shared)
    }
}
