//
//  AppSidebarNavigation.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/9/30.
//

import SwiftUI

enum NavigationItem: String {
    case codesign
    case makeDMG
    case notarizate
    case resetApp
}

struct SidebarView: View {
    @State private var text: String = ""
    @EnvironmentObject var appState: AppState
    @SceneStorage("searchText") var searchText = ""

    var body: some View {
        VStack {
            List {
                NavigationLink(tag: NavigationItem.codesign, selection: $appState.selection) {
                    CodesignView()
                        .environmentObject(appState)
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "checkmark.seal")
                            .font(.title)
                        Text(NavigationItem.codesign.rawValue)
                    }
                    .padding(10)
                }
                
                NavigationLink(tag: NavigationItem.makeDMG, selection: $appState.selection) {
                    MakeDMGView()
                        .environmentObject(appState)
                } label: {
                    HStack {
                        Image(systemName: "opticaldiscdrive")
                            .font(.title)
                        Text(NavigationItem.makeDMG.rawValue)
                    }
                    .padding(10)
                }
                
                NavigationLink(tag: NavigationItem.notarizate, selection: $appState.selection) {
                    NotaryView()
                        .environmentObject(appState)
                } label: {
                    HStack {
                        Image(systemName: "lock.shield")
                            .font(.title)
                        Text(NavigationItem.notarizate.rawValue)
                    }
                    .padding(10)
                }
                
                NavigationLink(tag: NavigationItem.resetApp, selection: $appState.selection) {
                    CleanCache()
                        .environmentObject(appState)
                } label: {
                    HStack {
                        Image(systemName: "gobackward")
                            .font(.title)
                        Text(NavigationItem.resetApp.rawValue)
                    }
                    .padding(10)
                }
            }
            .listStyle(.sidebar)
            
            Spacer()
            
            if appState.processing {
                ProgressView()
                  .frame(height: 20)
                  .padding(.bottom, 20)
            }
        }
        .frame(minWidth: 180, maxWidth: 360)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
