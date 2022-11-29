//
//  CodesignView.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/9/30.
//

import SwiftUI
import DeveloperKit

struct CodesignView: View {
    @State var openPanel = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            VStack {
                Picker("选择签名证书", selection: $appState.identity) {
                    ForEach(appState.findIdentity(), id: \.self) { title in
                        Text(title).tag(title)
                    }
                }
                .font(.headline)
                .pickerStyle(.automatic)
                .padding()
                
                HStack(alignment: .firstTextBaseline) {
                    TextField("输入渠道号，多个渠道号以,分隔", text: $appState.channelIDs)
                        .multilineTextAlignment(.leading)
                        .cornerRadius(8)
                }
                HStack() {
                    Toggle(isOn: $appState.needMakeDMG) {
                        Text("生成 DMG")
                            .bold()
                    }
                    Toggle(isOn: $appState.needNotarizate) {
                        Text("同步公证")
                            .bold()
                    }
                    Spacer()
                }
                .padding(.bottom, 20)
                
                HStack {
                    TextField("请选择一个 app 或者 dmg 格式文件", text: $appState.inputPath)
                        .multilineTextAlignment(.leading)
                        .cornerRadius(8)
                    Button {
                        openFile()
                    } label: {
                        Text("选择文件")
                            .bold()
                    }
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
        .navigationTitle("App 签名")
    }
    
    func openFile() {
        if let url = Panel.showOpen(fileTypes: [.applicationBundle])?.first {
            appState.inputPath = url.path
        }
    }
    
}

struct CodesignView_Previews: PreviewProvider {
    @State private var processing = false

    static var previews: some View {
        CodesignView()
            .environmentObject(AppState.shared)
    }
}
