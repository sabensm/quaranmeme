//
//  AppDelegate.swift
//  Quaranmeme
//
//  Created by Mike Sabens on 3/25/20.
//  Copyright © 2020 Slip3 Studios. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover = NSPopover.init()
    var statusBar: StatusBarController?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Create the Popover
        let popover = NSPopover()
        
        popover.contentViewController = MainViewController()
        popover.contentSize = NSSize(width: 500, height: 550)
        popover.contentViewController?.view = NSHostingView(rootView: ParentView(viewRouter: ViewRouter()))
        
        statusBar = StatusBarController.init(popover)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}
