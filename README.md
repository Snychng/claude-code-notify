# Claude Code Notify

macOS 通知工具，用于 Claude Code 完成任务时发送系统通知，支持自定义图标和点击跳转到终端窗口。

## 功能特性

- 🔔 Claude Code 完成任务时发送 macOS 系统通知
- 🎨 自定义通知图标（默认使用 Claude 图标）
- 🖱️ 点击通知自动跳转到运行 Claude Code 的终端窗口（Ghostty）
- 🔊 通知提示音

## 依赖

- macOS 10.14+
- Xcode Command Line Tools（用于编译 Swift）
- Claude 桌面应用（用于图标）

## 安装

### 1. 创建目录

```bash
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/claude-code-notify/ClaudeCodeNotify.app/Contents/{MacOS,Resources}
```

### 2. 编译 Swift 应用

```bash
swiftc -o ~/.local/share/claude-code-notify/ClaudeCodeNotify.app/Contents/MacOS/ClaudeCodeNotify \
    ClaudeCodeNotify.swift \
    -framework Cocoa \
    -O
```

### 3. 复制图标

```bash
cp /Applications/Claude.app/Contents/Resources/electron.icns \
   ~/.local/share/claude-code-notify/ClaudeCodeNotify.app/Contents/Resources/AppIcon.icns
```

### 4. 创建 Info.plist

```bash
cat > ~/.local/share/claude-code-notify/ClaudeCodeNotify.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>ClaudeCodeNotify</string>
    <key>CFBundleIdentifier</key>
    <string>com.claude.code.notify</string>
    <key>CFBundleName</key>
    <string>Claude Code Notify</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF
```

### 5. 安装通知脚本

```bash
cp claude-code-notify ~/.local/bin/claude-code-notify
chmod +x ~/.local/bin/claude-code-notify

# 确保 ~/.local/bin 在 PATH 中
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 6. 配置 Claude Code Hooks

编辑 `~/.claude/settings.json`，添加以下配置：

```json
{
  "hooks": {
    "Notification": [{
      "matcher": "",
      "hooks": [{ "type": "command", "command": "~/.local/bin/claude-code-notify" }]
    }],
    "Stop": [{
      "matcher": "",
      "hooks": [{ "type": "command", "command": "~/.local/bin/claude-code-notify" }]
    }]
  }
}
```

## 使用方法

脚本会在以下情况自动触发：
- Claude Code 完成任务时（Stop hook）
- Claude Code 需要用户输入时（Notification hook）

### 手动测试

```bash
claude-code-notify "测试消息"
```

## 自定义配置

### 修改图标

替换 `~/.local/share/claude-code-notify/ClaudeCodeNotify.app/Contents/Resources/AppIcon.icns` 文件。

### 修改跳转的终端应用

默认跳转到 Ghostty 终端的 "Claude Code" 窗口。如需修改，编辑 `ClaudeCodeNotify.swift` 中的 AppleScript：

```swift
// 跳转到 iTerm2
let script = """
tell application "iTerm2" to activate
"""

// 跳转到 Terminal.app
let script = """
tell application "Terminal" to activate
"""
```

修改后重新编译即可。

## 文件说明

- `claude-code-notify` - 启动脚本
- `ClaudeCodeNotify.swift` - Swift 通知应用源码

## License

MIT
