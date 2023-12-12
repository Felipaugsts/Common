//
//  UserRepository.swift
//  SportimeApp
//
//  Created by Felipe Augusto Silva on 15/07/23.
//

import Foundation
import KeychainSwift

public protocol UserDataSource {
    var user: User? { get set }
    var apiToken: String? { get set }
    
    func deleteUser()
    func addToUserDefaults<T: Codable>(_ data: T, forKey key: String)
    func retrieveFromUserDefaults<T: Codable>(forKey key: String) -> T?
}

final public class UserRepository: UserDataSource {
    
    public static var shared: UserDataSource = UserRepository()
    
    private var userDefaults: UserDefaults
    private var keychain: KeychainSwift
    private let userDataKey = "userData"
    
    public init(userDefaults: UserDefaults = UserDefaults.standard,
                keychain: KeychainSwift = KeychainSwift()) {
        self.userDefaults = userDefaults
        self.keychain = keychain
    }
    
    public var apiToken: String? {
        get {
            return retrieveTokenFromKeychain()
        }
        set {
            updateTokenInKeychain(with: newValue)
        }
    }

    private func retrieveTokenFromKeychain() -> String? {
        return keychain.get("apiToken")
    }

    private func updateTokenInKeychain(with token: String?) {
        guard let newToken = token else {
            keychain.delete("apiToken")
            return
        }
        keychain.set(newToken, forKey: "apiToken")
    }
    
    public var user: User? {
        get {
            guard let encodedData = UserDefaults.standard.data(forKey: "user") else {
                return nil
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: encodedData)
                return user
            } catch {
                print("Failed to decode user: \(error)")
                return nil
            }
        }
        set {
            do {
                let encodedData = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encodedData, forKey: "user")
            } catch {
                print("Failed to encode user: \(error)")
            }
        }
    }
    
    public func deleteUser() {
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
    public func addToUserDefaults<T: Codable>(_ data: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    public func retrieveFromUserDefaults<T: Codable>(forKey key: String) -> T? {
        if let storedData = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: storedData) {
                return decoded
            }
        }
        return nil
    }

}

public struct User: Codable {
    public var username: String?
    public var name: String?
    public var email: String?
    public var userUID: String?
}
