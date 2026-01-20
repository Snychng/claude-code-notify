import Foundation
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    var timeoutTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSUserNotificationCenter.default.delegate = self

        let args = CommandLine.arguments
        let message = args.count > 1 ? args[1] : "等待输入"
        let title = args.count > 2 ? args[2] : "Claude Code"

        let notif = NSUserNotification()
        notif.title = title
        notif.informativeText = message
        notif.soundName = NSUserNotificationDefaultSoundName

        NSUserNotificationCenter.default.deliver(notif)

        // 60 秒后自动退出
        timeoutTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { _ in
            NSApp.terminate(nil)
        }
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        timeoutTimer?.invalidate()

        // 激活 Ghostty 并跳转到 Claude Code 窗口
        let script = """
        tell application "System Events"
            tell process "Ghostty"
                set frontmost to true
                repeat with w in windows
                    if name of w contains "Claude Code" then
                        perform action "AXRaise" of w
                        exit repeat
                    end if
                end repeat
            end tell
        end tell
        """

        if let appleScript = NSAppleScript(source: script) {
            appleScript.executeAndReturnError(nil)
        }
        NSApp.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
