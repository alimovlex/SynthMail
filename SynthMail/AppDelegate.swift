/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import XCGLogger

let log = XCGLogger.default;
var MAIL_PARAMETERS = MailClientParameters();

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?;

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug);
        
        // Override point for customization after application launch.
        log.info(NSHomeDirectory());
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask);
        let documentsDirectory = urls.enumerated();
        log.info(documentsDirectory);
        
        if #available(iOS 12, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound, .provisional, .providesAppNotificationSettings, .criticalAlert]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }

        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
           return true
    }

}

