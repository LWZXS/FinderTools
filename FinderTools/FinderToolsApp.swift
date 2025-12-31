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
            
            // 检查插件是否已激活
            let isPluginActive = Self.checkPluginActivation()
            
            if isPluginActive {
                print("插件已激活，应用将退出")
            } else {
                print("插件未激活")
                // 可以在这里添加处理逻辑，比如提示用户激活插件
            }
            
            // 无论插件是否激活，都直接退出应用
            NSApp?.terminate(nil)
        }
    }
    
    var body: some Scene {
        // 保持一个空的Scene，但不显示任何窗口
        Settings {
            EmptyView()
        }
        .windowResizability(.contentSize)
        .commandsRemoved()
    }
    
    private static func checkPluginActivation() -> Bool {
        // 这里是检查插件是否激活的逻辑
        // 你需要根据你的实际插件类型来实现这个检查
        
        // 例如，对于系统扩展（System Extension）：
        // 1. 检查扩展是否已安装并激活
        // 2. 这通常涉及与系统扩展框架的交互
        
        // 临时返回 true 作为示例
        // 在实际应用中，你需要实现具体的检查逻辑
        return true
    }
}
