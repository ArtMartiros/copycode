//
//  AppDelegate.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Cocoa
import Mixpanel
import FirebaseCore
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private var sendToFirebaseItem = NSMenuItem(title: "Send screenshots for testing", action: #selector(sendToFirebase), keyEquivalent: "")
    private let shotCreator = ScreenShot()
    private let panel = PanelController()

    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        MSAppCenter.start("56df3f2d-4b0a-4f11-a474-44bcef230d48", withServices: [MSAnalytics.self, MSCrashes.self])
        setupMixpanel()
        firebaseSetup()
        createStatusBar()
        createMenu()
        listenGlobalKey()
//        Settings.clean()
    }

    func applicationWillTerminate(_ aNotification: Notification) {

    }
}

extension AppDelegate {
    private func createStatusBar() {
        let button = statusBar.button
        button?.image = NSImage(named: .init("picStatusBar"))
    }

    private func createMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Recognize text", action: #selector(screeenCapture), keyEquivalent: "e"))
        if !Settings.offFirebase {
            menu.addItem(sendToFirebaseItem)
            sendToFirebaseItem.state = Settings.sendToFirebaseEnabling ? .on : .off
        }
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q"))
        statusBar.menu = menu
    }

    @objc func screeenCapture() {
        Timer.start()
        Mixpanel.mainInstance().time(event: Mixpanel.kImageRecognize)
        let image = shotCreator.capture()
        Timer.stop(text: "screen shot")
        panel.openPanel(with: image!)
    }

    @objc func terminate() {
        NSApplication.shared.terminate(self)
    }

    @objc func sendToFirebase() {
        if sendToFirebaseItem.state == .off {
            sendToFirebaseItem.state = .on
            Settings.sendToFirebaseEnabling = true
            MSAnalytics.trackEvent("Firebase enable")
        } else {
            sendToFirebaseItem.state = .off
            Settings.sendToFirebaseEnabling = false
            MSAnalytics.trackEvent("Firebase disable")
        }

    }

    private func listenGlobalKey() {
        let flags = UInt(NSEvent.ModifierFlags.command.rawValue)
        let shortcut = MASShortcut(keyCode: UInt(kVK_ANSI_E), modifierFlags: flags)
        MASShortcutMonitor.shared()?.register(shortcut, withAction: { [weak self] in
            self?.screeenCapture()
        })
    }
}

extension AppDelegate {
    func firebaseSetup() {
        FirebaseApp.configure()
//        Auth.auth().signInAnonymously(completion: nil)
    }

    func setupMixpanel() {
        Mixpanel.initialize(token: "97a6727548d8d2d628ae7a0484441223")
        print("app versin: \(Bundle.main.version), bundle: \(Bundle.main.bundle)")
        Mixpanel.mainInstance().registerSuperProperties(["Release": Settings.release,
                                                         "Version": Bundle.main.version,
                                                         "Bundle": Bundle.main.bundle])
    }
}

extension Bundle {
   fileprivate var version: String {
        return self.infoDictionary?["CFBundleShortVersionString"]  as? String  ?? ""
    }

   fileprivate var bundle: String {
       return self.infoDictionary?["CFBundleVersion"]  as? String  ?? ""
    }
}
