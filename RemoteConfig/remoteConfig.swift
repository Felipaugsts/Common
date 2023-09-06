//
//  remoteConfig.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 16/07/23.
//

import Foundation
import Firebase

public final class RemoteConfig {
    static var shared = RemoteConfig()

    var remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings
}
