//
//  AuthService.swift
//  SportimeApp
//
//  Created by Felipe Augusto Silva on 15/07/23.
//

import Foundation
import FirebaseAuth

public protocol AuthServiceLogic {
    func authenticate(with email: String, password: String, completion: @escaping (Void?, Error?) -> Void)
    func isUserAuthenticated() -> Bool
    func updateUserEmail(_ email: String, completion: @escaping (Void?, Error?) -> Void)
    func updateUserPassword(_ password: String, completion: @escaping (Void?, Error?) -> Void)
    func sendPasswordResetEmail(_ email: String, completion: @escaping (Void?, Error?) -> Void)
    func logout(_ completion: @escaping (Void?, Error?) -> Void)
}

public class AuthService: AuthServiceLogic {
    
    public init() { }
    
    // MARK: - Authenticate
    
    public func authenticate(with email: String, password: String, completion: @escaping (Void?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { AuthDataResult, Error in
            if Error != nil {
                completion(nil, Error)
            } else if AuthDataResult != nil {
                
                let resp = AuthDataResult?.user
                
                var user = User()
                user.email = resp?.email
                user.name = resp?.displayName
                user.userUID = resp?.uid
                
                UserRepository.shared.user = user
                
                completion((), nil)
            }
        }
    }
    
    // MARK: - Is Authenticated
    
    public func isUserAuthenticated() -> Bool {
        let user = Auth.auth().currentUser
        
        guard user != nil &&
              user?.uid == UserRepository.shared.user?.userUID else {
            return false
        }
        
        return true
    }
    
    // MARK: - Update User Email
    
    public func updateUserEmail(_ email: String, completion: @escaping (Void?, Error?) -> Void) {
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            completion((), nil)
        }
    }
    
    // MARK: - Update User Password
    
    public func updateUserPassword(_ password: String, completion: @escaping (Void?, Error?) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            completion((), nil)
        }
    }
    
    // MARK: - Send Reset Email
    
    public func sendPasswordResetEmail(_ email: String, completion: @escaping (Void?, Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            completion((), nil)
        }
    }
    
    public func logout(_ completion: @escaping (Void?, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            UserRepository.shared.user = nil
            completion((), nil)
        } catch let error {
            print("Error trying to sign out of Firebase: \(error.localizedDescription)")
            completion(nil, error)
        }
        
    }
    
    // MARK: - Delete User
    
    public func deleteUser(_ completion: @escaping (Void?, Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                completion(nil, error)
            } else {
                completion((), nil)
            }
        }
    }
}
