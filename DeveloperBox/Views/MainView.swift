//
//  MainView.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/9/30.
//

import SwiftUI

struct MainView: View {
    @SceneStorage("searchText") var searchText = ""
    @StateObject var appState = AppState.shared
    @State var showSettingView = false

    var body: some View {
        ZStack {
            Color(NSColor.windowBackgroundColor)
            NavigationView {
                SidebarView()
                    .environmentObject(appState)
            }
            .toolbar {
                Toolbar(processing: $appState.processing, clean: $appState.cleanLog, setting: $showSettingView)
            }
            .sheet(isPresented: $showSettingView) {
                SettingView(setting: $showSettingView)
                    .environmentObject(appState)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView()
    }
}
