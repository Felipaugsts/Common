//
//  BiometryService.swift
//  SportimeApp
//
//  Created by Felipe Augusto Silva on 15/07/23.
//

import Foundation
import LocalAuthentication
import KeychainSwift

public protocol BiometryWorkerLogic {
    func authenticate(completion: @escaping(Bool) -> Void)
    func isBiometyEnabled() -> Bool?
    func setBiometryData(_ username: String, _ password: String)
    func setBiometryEnabled(_ value: Bool?)
    func clear()
}

public class BiometryWorker: BiometryWorkerLogic {
    
    private let context: LAContext
    private let keychain: KeychainSwift
    private let preferences: UserDefaults
    
    public init(keychain: KeychainSwift = KeychainSwift(),
         preferences: UserDefaults = UserDefaults.standard,
         context: LAContext = LAContext()) {
        self.keychain = keychain
        self.preferences = preferences
        self.context = context
    }
    
    private struct Keys {
        static let isBiometricsEnabledKey = "biometryEnabledKey"
        static let biometricsUsernameKey = "biometryUsernameKey"
        static let biometricsPasswordKey = "biometryPasswordKey"
        static let policyDomainStateDataKey = "policyDomainStateKey"
    }
    
    public func authenticate(completion: @escaping(Bool) -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use sua digital pra acessar de forma rápida sua conta.") { success, errr in
            DispatchQueue.main.async { completion(success) }
        }
    }
    
    public func isBiometyEnabled() -> Bool? {
        return preferences.object(forKey: Keys.isBiometricsEnabledKey) as? Bool
    }
    
    public func setBiometryData(_ username: String, _ password: String) {
        let usernameKey = Keys.biometricsUsernameKey
        let passwordKey = Keys.biometricsPasswordKey
        
        keychain.set(username, forKey: usernameKey)
        keychain.set(password, forKey: passwordKey)
    }
    
    public func setBiometryEnabled(_ value: Bool?) {
        preferences.set(value, forKey: Keys.isBiometricsEnabledKey)
        if value == true {
            setPolicyDomainStateData()
        }
    }
    
    private func setPolicyDomainStateData() {
        canEvaluatePolicy()
        guard let data = self.context.evaluatedPolicyDomainState else { return }
        keychain.set(data, forKey: Keys.policyDomainStateDataKey)
    }
    
    @discardableResult
    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) &&
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    public func clear() {
        setBiometryEnabled(nil)
        keychain.delete(Keys.biometricsUsernameKey)
        keychain.delete(Keys.biometricsPasswordKey)
    }
    
    public func biometryData() -> (String, String) {
        let usernameKey = Keys.biometricsUsernameKey
        let passwordKey = Keys.biometricsPasswordKey
        
        let username = keychain.get(usernameKey) ?? ""
        let password = keychain.get(passwordKey) ?? ""
        
        return (username, password)
    }
}

public struct BiometryResponse {
    public var username: String?
    public var password: String?
    
    public init(username: String?,
                password: String?) {
        self.username = username
        self.password = password
    }
}
