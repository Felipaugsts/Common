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
    
    func deleteUser()
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
}

public struct User: Codable {
    public var username: String?
    public var name: String?
    public var email: String?
    public var userUID: String?
}
