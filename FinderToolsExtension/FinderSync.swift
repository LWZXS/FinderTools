//
//  FinderSync.swift
//  FinderToolsExtension
//
//  Created by LinWeiZhao on 2025/3/11.
//

import Cocoa
import FinderSync


class FinderSync: FIFinderSync {
    // 使用 lazy var 确保 NSWindow 只初始化一次
    lazy var sharedWindow: NSWindow = {
        let windowWidth: CGFloat = 500
        let windowHeight: CGFloat = 200
        
        let windowRect = NSMakeRect(0, 0, windowWidth, windowHeight)
        let windowStyleMask: NSWindow.StyleMask = [.titled, .miniaturizable]
        let window = NSWindow(contentRect: windowRect, styleMask: windowStyleMask, backing: .buffered, defer: false)
        
        if let screenVisibleFrame = NSScreen.main?.visibleFrame {
            // 计算窗口的中心位置
            let windowOriginX = screenVisibleFrame.midX - windowWidth / 2
            let windowOriginY = screenVisibleFrame.midY - windowHeight / 2
            
            let center = NSPoint(x: windowOriginX, y: windowOriginY)
            window.setFrameOrigin(center)
            window.level = .floating
        }
        return window
    }()
    
    override init() {
        super.init()
                
        // 初始化时更新监听路径
        updateDirectoryURLs()
        
        // 监听外接设备的插入和拔出事件
        setupDeviceNotifications()
        
    }
    
    
    // 更新监听路径
    func updateDirectoryURLs() {
        let rootURL = URL(fileURLWithPath: "/")
        let volumesURL = URL(fileURLWithPath: "/Volumes")
        var directoryURLs: [URL] = [rootURL, volumesURL]
        
        // 获取 /Volumes 下的所有挂载点
        if let mountedVolumes = try? FileManager.default.contentsOfDirectory(at: volumesURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
            directoryURLs.append(contentsOf: mountedVolumes)
        }
        
        // 更新监听路径
        FIFinderSyncController.default().directoryURLs = Set(directoryURLs)
    }
    
    // 设置外接设备插入和拔出的通知
    func setupDeviceNotifications() {
        let workspace = NSWorkspace.shared
        let notificationCenter = workspace.notificationCenter
        
        // 监听设备挂载（插入）
        notificationCenter.addObserver(
            self,
            selector: #selector(deviceDidMount(_:)),
            name: NSWorkspace.didMountNotification,
            object: nil
        )
        
        // 监听设备卸载（拔出）
        notificationCenter.addObserver(
            self,
            selector: #selector(deviceDidUnmount(_:)),
            name: NSWorkspace.didUnmountNotification,
            object: nil
        )
    }
    
    // 设备挂载时的回调
    @objc func deviceDidMount(_ notification: Notification) {
        updateDirectoryURLs() // 更新监听路径
    }
    
    // 设备卸载时的回调
    @objc func deviceDidUnmount(_ notification: Notification) {
        updateDirectoryURLs() // 更新监听路径
    }
    
    deinit {
        // 移除通知监听
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
    // 添加自定义菜单项
    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "")
        
        // 添加“新建”菜单项
        let newItem = NSMenuItem(title: "新建", action: nil, keyEquivalent: "")
        let newSubMenu = NSMenu(title: "新建")
        
        // 添加“新建 txt”子菜单项
        let newTxtItem = NSMenuItem(
            title: "新建 txt",
            action: #selector(createTxtFile(_:)),
            keyEquivalent: ""
        )
        newTxtItem.target = self
        newSubMenu.addItem(newTxtItem)
        
        // 添加“新建 docx”子菜单项
        let newDocxItem = NSMenuItem(
            title: "新建 docx",
            action: #selector(createDocxFile(_:)),
            keyEquivalent: ""
        )
        newDocxItem.target = self
        newSubMenu.addItem(newDocxItem)
        
        // 添加“新建 xlsx”子菜单项
        let newXlsxItem = NSMenuItem(
            title: "新建 xlsx",
            action: #selector(createXlsxFile(_:)),
            keyEquivalent: ""
        )
        newXlsxItem.target = self
        newSubMenu.addItem(newXlsxItem)
        
        // 添加“新建 pptx”子菜单项
        let newPptxItem = NSMenuItem(
            title: "新建 pptx",
            action: #selector(createPptxFile(_:)),
            keyEquivalent: ""
        )
        newPptxItem.target = self
        newSubMenu.addItem(newPptxItem)
        
        // 将子菜单添加到“新建”菜单项
        newItem.submenu = newSubMenu
        menu.addItem(newItem)
        
        // 添加“打开终端”菜单项
        let openTerminalItem = NSMenuItem(
            title: "打开终端",
            action: #selector(openTerminal(_:)),
            keyEquivalent: ""
        )
        openTerminalItem.target = self
        menu.addItem(openTerminalItem)
        
        // 添加“拷贝路径”菜单项
        let copyPathItem = NSMenuItem(
            title: "拷贝路径",
            action: #selector(copyPath(_:)),
            keyEquivalent: ""
        )
        copyPathItem.target = self
        menu.addItem(copyPathItem)
        
        return menu
    }
    
    
    // 新建 txt 文件
    @objc func createTxtFile(_ sender: AnyObject?) {
        // 创建 TXT 文件
        return createFile(nil, fileExtension: "txt", defaultFileName: "Untitled")
    }
    

    // 新建 docx 文件
    @objc func createDocxFile(_ sender: AnyObject?) {
        // 创建 docx 文件
        return createFile(nil, fileExtension: "docx", defaultFileName: "Untitled")
    }
    
    // 新建 excel 文件
    @objc func createXlsxFile(_ sender: AnyObject?) {
        // 创建 excel 文件
        return createFile(nil, fileExtension: "xlsx", defaultFileName: "Untitled")
    }
    
    // 新建 pptx 文件
    @objc func createPptxFile(_ sender: AnyObject?) {
        // 创建 pptx 文件
        return createFile(nil, fileExtension: "pptx", defaultFileName: "Untitled")
    }
    
    // 显示弹窗
    private func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        
        // 在主线程中显示弹窗
        DispatchQueue.main.async {
            alert.runModal()
        }
    }
    
    //新建文件
    @objc func createFile(_ sender: AnyObject?, fileExtension: String, defaultFileName: String) {
        guard let targetURL = FIFinderSyncController.default().targetedURL() else {
            showAlert(title: "错误", message: "无法获取目标目录")
            return
        }
        
        DispatchQueue.main.async {
            // 创建并配置保存面板
            let savePanel = NSSavePanel()
            savePanel.nameFieldStringValue = "\(defaultFileName).\(fileExtension)"
            savePanel.directoryURL = targetURL
            savePanel.showsTagField = false
            savePanel.canCreateDirectories = false
            
            // 使用 beginSheetModal(for:completionHandler:) 显示对话框
            savePanel.beginSheetModal(for: self.sharedWindow) { response in
                self.sharedWindow.orderOut(nil)
                if response == .OK, let url = savePanel.url {
                    // 根据文件类型写入内容
                    switch fileExtension {
                    case "txt":
                        let text = ""
                        do {
                            try text.write(to: url, atomically: true, encoding: .utf8)
                        } catch {
                            self.showAlert(title: "错误", message: "保存 TXT 文件失败：\(error.localizedDescription)")
                        }
                    case "docx":
                        let templatePath = Bundle.main.path(forResource: "Template", ofType: "docx")
                        if let templatePath = templatePath {
                            do {
                                try FileManager.default.copyItem(atPath: templatePath, toPath: url.path)
                            } catch {
                                print("创建 DOCX 文件失败：\(error.localizedDescription)")
                                self.showAlert(title: "错误", message: "保存 DOCX 文件失败：\(error.localizedDescription)")
                            }
                        }
                    case "xlsx":
                        let templatePath = Bundle.main.path(forResource: "Template", ofType: "xlsx")
                        if let templatePath = templatePath {
                            do {
                                try FileManager.default.copyItem(atPath: templatePath, toPath: url.path)
                            } catch {
                                print("创建 XLSX 文件失败：\(error.localizedDescription)")
                                self.showAlert(title: "错误", message: "保存 XLSX 文件失败：\(error.localizedDescription)")
                            }
                        }
                        
                    case "pptx":
                        let templatePath = Bundle.main.path(forResource: "Template", ofType: "pptx")
                        if let templatePath = templatePath {
                            do {
                                try FileManager.default.copyItem(atPath: templatePath, toPath: url.path)
                            } catch {
                                print("创建 PPTX 文件失败：\(error.localizedDescription)")
                                self.showAlert(title: "错误", message: "保存 PPTX 文件失败：\(error.localizedDescription)")
                            }
                        }
                    default:
                        print("不支持的文件类型：\(fileExtension)")
                    }
                }
            }
        }
    }
    
    
    // 打开终端
    @objc func openTerminal(_ sender: AnyObject?) {
        guard let selectedItems = FIFinderSyncController.default().selectedItemURLs() else {
            return
        }
        
        for itemURL in selectedItems {
            // 打印 itemURL
            NSLog("Selected item URL: %@", itemURL.path)
            let success = TerminalHelper.openTerminal(atPath: itemURL.path)
        }
    }
    
    
    // 拷贝路径
    @objc func copyPath(_ sender: AnyObject?) {
        guard let selectedItems = FIFinderSyncController.default().selectedItemURLs() else {
            return
        }
        
        // 将所有选中的路径拼接成一个字符串
        let paths = selectedItems.map { $0.path }.joined(separator: "\n")
        
        // 将路径复制到剪贴板
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(paths, forType: .string)
        
        NSLog("Copied paths: %@", paths)
    }
}



