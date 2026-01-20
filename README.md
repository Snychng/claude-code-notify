# Claude Code Notify

macOS 通知工具，用于 Claude Code 完成任务时发送系统通知，支持自定义图标和点击跳转到终端窗口。

## 功能特性

- 🔔 Claude Code 完成任务时发送 macOS 系统通知
- 🎨 自定义通知图标（默认使用 Claude 图标）
- 🖱️ 点击通知自动跳转到运行 Claude Code 的终端窗口
- 🔊 通知提示音

## 依赖

- macOS 10.14+
- [terminal-notifier](https://github.com/julienXX/terminal-notifier)：`brew install terminal-notifier`
- Claude 桌面应用（用于图标）

## 安装

### 1. 安装 terminal-notifier

```bash
brew install terminal-notifier
```

### 2. 安装通知脚本

```bash
# 创建目录
mkdir -p ~/.local/bin

# 复制脚本
cp claude-notify ~/.local/bin/claude-notify
chmod +x ~/.local/bin/claude-notify

# 确保 ~/.local/bin 在 PATH 中
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 3. 配置 Claude Code Hooks

编辑 `~/.claude/settings.json`，添加以下配置：

```json
{
  "hooks": {
    "Notification": [{
      "matcher": "",
      "hooks": [{ "type": "command", "command": "~/.local/bin/claude-notify" }]
    }],
    "Stop": [{
      "matcher": "",
      "hooks": [{ "type": "command", "command": "~/.local/bin/claude-notify" }]
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
claude-notify "测试消息"
```

## 自定义配置

### 修改图标

编辑 `claude-notify` 脚本，修改 `-contentImage` 参数：

```bash
-contentImage "/path/to/your/icon.icns"
```

### 修改跳转的终端应用

默认跳转到 Ghostty 终端的 "Claude Code" 窗口。如需修改，编辑脚本中的 `ACTIVATE_CMD`：

```bash
# 跳转到 iTerm2
ACTIVATE_CMD='osascript -e "tell application \"iTerm2\" to activate"'

# 跳转到 Terminal.app
ACTIVATE_CMD='osascript -e "tell application \"Terminal\" to activate"'
```

## 文件说明

- `claude-notify` - 主脚本，使用 terminal-notifier 发送通知
- `ClaudeNotify.swift` - Swift 版本（备用方案，支持原生 API）

## Swift 版本（可选）

如果你更喜欢使用原生 Swift 应用：

```bash
# 创建应用目录
mkdir -p ~/.local/share/claude-notify/ClaudeNotify.app/Contents/{MacOS,Resources}

# 编译 Swift 应用
swiftc -o ~/.local/share/claude-notify/ClaudeNotify.app/Contents/MacOS/ClaudeNotify \
    ClaudeNotify.swift \
    -framework Cocoa \
    -O

# 复制图标
cp /Applications/Claude.app/Contents/Resources/electron.icns \
   ~/.local/share/claude-notify/ClaudeNotify.app/Contents/Resources/AppIcon.icns

# 创建 Info.plist
cat > ~/.local/share/claude-notify/ClaudeNotify.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>ClaudeNotify</string>
    <key>CFBundleIdentifier</key>
    <string>com.claude.notify</string>
    <key>CFBundleName</key>
    <string>Claude Notify</string>
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

## License

MIT
