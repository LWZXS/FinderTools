//
//  FinderToolsApp.swift
//  FinderTools
//
//  Created by LinWeiZhao on 2025/3/11.
//

import SwiftUI

@main
struct FinderToolsApp: App {
    init() {
        DispatchQueue.main.async {
            NSApp?.setActivationPolicy(.accessory)
        }
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
        }
    }
}
