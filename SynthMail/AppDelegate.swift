/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import XCGLogger

let log = XCGLogger.default;
var MAIL_PARAMETERS = MailClientParameters();
let userDefaults = UserDefaults.standard;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug);
        
           return true
    }

}

