//
//  SDKCommonInjection.swift
//  FBSnapshotTestCase
//
//  Created by FELIPE AUGUSTO SILVA on 18/11/22.
//

import Foundation

public enum SDKCommonAssemblies {
    public static func register() {
        AppAssembler.apply(SDKCommonRegistration())
    }
}

final class SDKCommonRegistration: AppAssembly {
    func assemble(container: AppsContainer) {
        container.autoregister(HTTPRequestProtocol.self, initializer: DefaultHTTPRequest.init)
    }
}
