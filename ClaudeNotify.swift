import Foundation
import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    var targetWindowTitle: String?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSUserNotificationCenter.default.delegate = self

        let args = CommandLine.arguments
        let message = args.count > 1 ? args[1] : "等待输入"
        let title = args.count > 2 ? args[2] : "Claude Code"
        targetWindowTitle = args.count > 3 ? args[3] : nil

        let notif = NSUserNotification()
        notif.title = title
        notif.informativeText = message
        notif.soundName = NSUserNotificationDefaultSoundName
        if let windowTitle = targetWindowTitle {
            notif.userInfo = ["windowTitle": windowTitle]
        }

        NSUserNotificationCenter.default.deliver(notif)

        // 发送后立即退出，点击处理交给系统
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            NSApp.terminate(nil)
        }
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
