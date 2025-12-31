//
//  FinderToolsApp.swift
//  FinderTools
//
//  Created by LinWeiZhao on 2025/3/11.
//


import SwiftUI
import AppKit

@main
struct FinderToolsApp: App {
    @StateObject private var pluginChecker = PluginChecker()
    
    var body: some Scene {
        WindowGroup {
            PluginStatusView()
                .frame(width: 400, height: 300)
                .environmentObject(pluginChecker)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}

class PluginChecker: ObservableObject {
    @Published var isPluginActive = false
    @Published var showAlert = false
    
    func checkPlugin() {
        // 模拟检查过程
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            #if DEBUG
            self.isPluginActive = Bool.random()
            #else
            self.isPluginActive = true
            #endif
            self.showAlert = true
            
            // 3秒后自动关闭应用
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                NSApp?.terminate(nil)
            }
        }
    }
}

struct PluginStatusView: View {
    @EnvironmentObject var pluginChecker: PluginChecker
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack(spacing: 20) {
            if pluginChecker.isPluginActive {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("插件已激活")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Text("所有功能正常运行")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                
                Text("插件未激活")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                
                Text("需要激活插件才能使用完整功能")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Button("激活插件") {
                    openPluginSettings()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text("窗口将在3秒后自动关闭")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(30)
        .onAppear {
            // 设置激活策略
            NSApp?.setActivationPolicy(.regular)
            
            // 开始检查插件
            pluginChecker.checkPlugin()
        }
    }
    
    private func openPluginSettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preferences.extensions")!
        NSWorkspace.shared.open(url)
    }
}
