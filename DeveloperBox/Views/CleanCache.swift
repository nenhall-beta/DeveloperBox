//
//  CleanCache.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/9/30.
//

import SwiftUI

struct CleanCache: View {
    @State var openPanel = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("请选择一个要清理的 app ", text: $appState.inputPath)
                        .multilineTextAlignment(.leading)
                        .cornerRadius(8)
                    Button {
                        openFile()
                    } label: {
                        Text("选择应用")
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
        .navigationTitle("缓存清理")
    }
    
    func openFile() {
        if let url = Panel.showOpen(fileTypes: [.applicationBundle])?.first {
            appState.inputPath = url.path
        }
    }

}

struct CleanCache_Previews: PreviewProvider {
    @State private static var processing = false

    static var previews: some View {
        CleanCache()
            .environmentObject(AppState.shared)
    }
}
