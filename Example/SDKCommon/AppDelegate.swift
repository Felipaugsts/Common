//
//  AppDelegate.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 09/13/2022.
//  Copyright (c) 2022 Felipe Augusto Silva. All rights reserved.
//

import UIKit
import SDKCommon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerAssemblies()

        return true
    }

    private func registerAssemblies() {
        SDKCommonAssemblies.register()
    }
}

