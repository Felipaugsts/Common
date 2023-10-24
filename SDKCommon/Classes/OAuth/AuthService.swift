//
//  AuthService.swift
//  SportimeApp
//
//  Created by Felipe Augusto Silva on 15/07/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

public protocol AuthServiceLogic {
    func authenticate(with email: String, password: String, completion: @escaping (Void?, APIError?) -> Void)
    func isUserAuthenticated() -> Bool
    func updateUserEmail(_ email: String, completion: @escaping (Void?, Error?) -> Void)
    func updateUsername(_ name: String, completion: @escaping (Void?, Error?) -> Void)
    func updateUserPassword(_ password: String, completion: @escaping (Void?, Error?) -> Void)
    func sendPasswordResetEmail(_ email: String, completion: @escaping (Void?, Error?) -> Void)
    func logout(_ completion: @escaping (Void?, Error?) -> Void)
    func createAccount(email: String, password: String, completion: @escaping (Void?, APIError?) -> Void)
    func getCurrentUser() -> CurrentUser?
    func createFirestoreDocument<T: Encodable>(collectionName: String, documentID: String, data: T, completion: @escaping (Result<Void, Error>) -> Void)
    func getFirestoreDocument<T: Decodable>(_ collectionName: String, documentID: String, objectType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func saveUserData(completion: @escaping (Bool) -> Void)
}

public class AuthService: AuthServiceLogic {
    
    public init() { }
    
    public let db = Firestore.firestore()
    
    // MARK: - Authenticate
    
    public func authenticate(with email: String, password: String, completion: @escaping (Void?, APIError?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let errorCode = error._code
                
                switch errorCode {
                case AuthErrorCode.wrongPassword.rawValue:
                    completion(nil, .customError(statusCode: 403, result: nil)) // Wrong password
                case AuthErrorCode.userNotFound.rawValue:
                    completion(nil, .customError(statusCode: 404, result: nil)) // User not found
                default:
                    completion(nil, .unknown)
                }
            } else if authResult != nil {
                self.saveUserData { _ in
                    completion((), nil)
                }
            }
        }
    }

    
    // MARK: - Get current User
    
    public func getCurrentUser() -> CurrentUser? {
        let user = Auth.auth().currentUser
        
        guard user != nil else {
            return nil
        }
        return CurrentUser(uid: user?.uid, username: user?.displayName, email: user?.email)
    }
    
    public func saveUserData(completion: @escaping (Bool) -> Void) {
        guard let userID = getCurrentUser()?.uid else {
            completion(false)
            return
        }
        let userCollection = db.collection("Users").document(userID)
                
        getFirestoreDocument("Users", documentID: userID, objectType: User.self) { userResponse in
            switch userResponse {
            case .success(let userResult):
                var user = userResult
                UserRepository.shared.user = user
                completion(true)
            case .failure:
                completion(false) // Notify the caller that the operation failed
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
                print(error?.localizedDescription ?? "")
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
                print(error?.localizedDescription ?? "")
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
                print(error?.localizedDescription ?? "")
                completion(nil, error)
                return
            }
            
            completion((), nil)
        }
    }
    
    // MARK: - Logout
    
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
    
    // MARK: - Create User
    
    public func createAccount(email: String, password: String, completion: @escaping (Void?, APIError?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                let errorCode = error._code
                
                switch errorCode {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(nil, .customError(statusCode: 403, result: nil)) // Email in use
                case AuthErrorCode.invalidEmail.rawValue, AuthErrorCode.missingEmail.rawValue:
                    completion(nil, .customError(statusCode: 400, result: nil)) // Invalid Email
                default:
                    completion(nil, .unknown)
                }
            } else if let user = authResult?.user {
                print("\(String(describing: user.email)) created")
                completion((), nil)
            }
        }
    }
    
    // MARK: - Update User Name
    
    public func updateUsername(_ name: String, completion: @escaping (Void?, Error?) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { Error in
            guard let error = Error else {
                
                completion((), nil)
                return
            }
            completion(nil, error)
        }
    }
}

public struct CurrentUser {
    public var uid: String?
    public var username: String?
    public var email: String?
}
