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
    private var service: AuthServiceLogic
    private let userDataKey = "userData"
    
    public init(userDefaults: UserDefaults = UserDefaults.standard,
                keychain: KeychainSwift = KeychainSwift(),
                service: AuthServiceLogic = AuthService()) {
        self.userDefaults = userDefaults
        self.keychain = keychain
        self.service = service
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
    
    public func getUserBudget() {
        
    }
}

public struct User: Codable {
    public var username: String?
    public var name: String?
    public var email: String?
    public var userUID: String?
    public var budget: YearBudget? = nil
}

public struct YearBudget: Codable {
    public let year: Int
    public let yearBudget: [MonthData]
    
    public init(year: Int, yearBudget: [MonthData]) {
        self.year = year
        self.yearBudget = yearBudget
    }
}

public struct MonthData: Codable {
    public var month: String?
    public var incoming: [IncomingData]
    public var expenses: [ExpenseData]
    
    public init(month: String, incoming: [IncomingData], expenses: [ExpenseData]) {
        self.month = month
        self.incoming = incoming
        self.expenses = expenses
    }
}

public struct IncomingData: Codable {
    public var totalIncoming: Int?
    public var people: [PersonData]
    
    public init(totalIncoming: Int, people: [PersonData]) {
        self.totalIncoming = totalIncoming
        self.people = people
    }
}

public struct PersonData: Codable {
    public var personId: Int?
    public var name: String?
    public var value: Int?
    
    public init(personId: Int, name: String, value: Int) {
        self.personId = personId
        self.name = name
        self.value = value
    }
}

public struct ExpenseData: Codable {
    var totalExpenses: Int?
    var creditCards: [Int]?
    var house: [Int]?
    var education: [Int]?
    
    public init(totalExpenses: Int, creditCards: [Int], house: [Int], education: [Int]) {
        self.totalExpenses = totalExpenses
        self.creditCards = creditCards
        self.house = house
        self.education = education
    }
}
