//
//  MainView.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/9/30.
//

import SwiftUI

struct MainView: View {
    @SceneStorage("searchText") var searchText = ""
    @StateObject var appState = AppState()

    var body: some View {
        NavigationView {
            SidebarView()
                .environmentObject(appState)
        }
        .toolbar {
            Toolbar(processing: $appState.processing, clean: $appState.cleanLog)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView()
    }
}
