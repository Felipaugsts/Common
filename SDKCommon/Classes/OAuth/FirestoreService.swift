//
//  FirestoreService.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 12/10/23.
//
//
import Foundation
import FirebaseFirestore

extension AuthService {
    
    public func createFirestoreDocument<T: Encodable>(collectionName: String, documentID: String, data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = db.collection(collectionName).document(documentID)
        
        do {
            // Convert the generic data to a dictionary
            let jsonData = try JSONEncoder().encode(data)
            let dataDict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
            
            if let dataDict = dataDict {
                ref.setData(dataDict, merge: true) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } else {
                completion(.failure(FirestoreError.serializationError))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    public func getFirestoreDocument<T: Decodable>(_ collectionName: String, documentID: String, objectType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let db = Firestore.firestore()
        let documentReference = db.collection(collectionName).document(documentID)
        
        documentReference.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                do {
                    if let data = document.data() {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let decodedObject = try JSONDecoder().decode(objectType, from: jsonData)
                        completion(.success(decodedObject))
                    } else {
                        let decodingError = NSError(domain: "FirestoreDecodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode Firestore data"])
                        completion(.failure(decodingError))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                let documentNotFoundError = NSError(domain: "FirestoreDocumentNotFoundError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                completion(.failure(documentNotFoundError))
            }
        }
    }
    
    func decodeDictionaryToModel<T: Decodable>(_ dictionary: [String: Any], targetType: T.Type) -> T? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
            let decoder = JSONDecoder()
            let model = try decoder.decode(targetType, from: jsonData)
            return model
        } catch {
            print("Error decoding dictionary to \(T.self): \(error)")
            return nil
        }
    }
    
    enum FirestoreError: Error {
        case serializationError
    }
}
