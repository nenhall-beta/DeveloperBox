//
//  Toolbar.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/10/9.
//

import SwiftUI

struct Toolbar: CustomizableToolbarContent {
    @Binding var processing: Bool
    @Binding var clean: Bool

    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "toggleSidebar", placement: .navigation, showsByDefault: true) {
            Button {
                toggleSidebar()
            } label: {
                Image(systemName: "sidebar.left")
            }
            .help("Toggle Sidebar")
        }
        
        ToolbarItem(id: "Clear", placement: .primaryAction, showsByDefault: true) {
            Button {
                clean.toggle()
            } label: {
                Image(systemName: "paintbrush.fill")
            }
        }
        
        ToolbarItem(id: "run", placement: .primaryAction, showsByDefault: true) {
            Button {
                processing.toggle()
            } label: {
                Image(systemName: processing ? "stop.fill" : "play.fill")
                Text("Run")
            }
        }
    }
    
    func toggleSidebar() {
        NSApp.keyWindow?
            .contentViewController?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
