//
//  TestView.swift
//  AppComponent
//
//  Created by FELIPE AUGUSTO SILVA on 02/12/22.
//

import SwiftUI

public protocol AppExternalDelegateProtocol {

    func didClickButton()

}

public class appCommonModuleTest {

        // MARK: - Properties
    private var externalDelegate: AppExternalDelegateProtocol?
    public static let instance = appCommonModuleTest()

    public func initFeature(externalDelegate: AppExternalDelegateProtocol?) {
        self.externalDelegate = externalDelegate
    }

    internal func getExternalDelegate() -> AppExternalDelegateProtocol? {
        return externalDelegate
    }

}

@available(iOS 13.0, *)
public struct TestView: View {

    public init() {}

    public var body: some View {
        VStack {
            Text("Other module view")

            Button("Send action back to other module") {
                appCommonModuleTest.instance.getExternalDelegate()?.didClickButton()
            }
        }
    }
}

