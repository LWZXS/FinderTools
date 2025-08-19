//
//  TerminalHelper.m
//  FinderToolsExtension
//
//  Created by LinWeiZhao on 2025/3/13.
//

#import "TerminalHelper.h"
#import <Cocoa/Cocoa.h>

@implementation TerminalHelper

+ (BOOL)openTerminalAtPath:(NSString *)path {
    if (path == nil || [path length] == 0) {
        return NO; // 路径为空，返回失败
    }
    
    // 检查路径是否存在
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] || !isDir) {
        return NO; // 不是有效的文件夹
    }

    // 创建剪贴板
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
    [pasteboard clearContents];
    [pasteboard setString:path forType:NSPasteboardTypeString];

    // 尝试打开 macOS Terminal
    BOOL success = NSPerformService(@"New Terminal at Folder", pasteboard);
    
    return success;
}

@end

