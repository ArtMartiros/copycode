//
//  AppDelegate.swift
//  CopyCode
//
//  Created by Артем on 18/07/2018.
//  Copyright © 2018 Artem Martirosyan. All rights reserved.
//

import Cocoa
import Mixpanel

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let shotCreator = ScreenShot()
    let panel = PanelController()
    
    let statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Mixpanel.initialize(token: "97a6727548d8d2d628ae7a0484441223")
        
        Mixpanel.mainInstance().registerSuperProperties(["Release": Settings.release])
//        BITHockeyManager.shared().configure(withIdentifier: "56df3f2d4b0a4f11a47444bcef230d48")
//        // Do some additional configuration if needed here
//        //больше не должно требовать пароля
//        BITHockeyManager.shared()?.isMetricsManagerDisabled = false
//        BITHockeyManager.shared().start()
        

        createStatusBar()
        createMenu()
        listenGlobalKey()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
}

extension AppDelegate {
    private func createStatusBar() {
        if let button = statusBar.button {
            button.image = NSImage(named: .init("tabIcon"))
        }
    }
    
    private func createMenu() {
        let menu = NSMenu()
        let screenCaptureItem = NSMenuItem(title: "Capture Screen", action: #selector(screeenCapture), keyEquivalent: "s")
        let exitItem = NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "")
        
        menu.addItem(screenCaptureItem)
        menu.addItem(exitItem)
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
    
    private func listenGlobalKey() {
        let flags = UInt(NSEvent.ModifierFlags.command.rawValue + NSEvent.ModifierFlags.shift.rawValue)
        let shortcut = MASShortcut(keyCode: UInt(kVK_ANSI_K), modifierFlags: flags)
        MASShortcutMonitor.shared()?.register(shortcut, withAction: { [weak self] in
            self?.screeenCapture()
        })
    }
}
