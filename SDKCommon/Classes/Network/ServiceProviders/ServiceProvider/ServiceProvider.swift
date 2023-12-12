//
//  ServiceProvider.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 06/09/23.
//

import Foundation
import UIKit

// MARK: - Protocols

public protocol RequestProvider {
    var path: String { get set }
    var module: String { get set  }
    var httpMethod: RequestHTTPMethod { get set  }
    var body: [String: Any] { get set  }
    var isPublic: Bool { get set  }
    var headers: [String: String] { get set }
}

public protocol APIRequestProvider: RequestProvider { }

public extension APIRequestProvider {
    var module: String { "" }
    var isPublic: Bool { false }

}

// MARK: - Service Provider Protocol

public protocol ServiceProviderProtocol {
    func configureBaseURL(url: String, token: String)
    func makeAPIRequest<T: Decodable>(_ model: T.Type, using provider: RequestProvider, completionHandler: @escaping (Result<T, APIError>) -> Void)
}

// MARK: - Service Provider Implementation

public class ServiceProvider: ServiceProviderProtocol {
    private var baseURL: String?

    public static var shared: ServiceProviderProtocol = {
        ServiceProvider()
    }()
    var repository: UserDataSource
    
    public init(repository: UserDataSource = UserRepository.shared) {
        self.repository = repository
    }

    // MARK: - Public Methods
    
    public func configureBaseURL(url: String, token: String) {
        guard let _ = URL(string: url) else {
            print("Couldn't configure BASE URL: \(url)")
            return
        }
        
        repository.apiToken = token
        baseURL = url
    }

    
    public func makeAPIRequest<T: Decodable>(_ model: T.Type, using provider: RequestProvider, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        
        guard let baseURL = baseURL,
              let fullURL = URL(string: baseURL + provider.module + provider.path) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: fullURL)
        
        request.httpMethod = provider.httpMethod.rawValue
        
        // Configure headers from the provider.
        configureHeaders(for: provider.headers, in: &request)

        print("endpoint:", fullURL)
        
        // Set the request body for POST requests.
        if provider.httpMethod == .post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: provider.body)
            } catch {
                completionHandler(.failure(.mappingError))
                return
            }
        }

        // Perform the network request asynchronously.
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let failureReason = error.localizedDescription
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completionHandler(.failure(.requestFailed(statusCode, failureReason, response as? HTTPURLResponse, nil)))
                return
            }

            guard let data = data else {
                completionHandler(.failure(.unknown))
                return
            }

            do {
                let decodedModel = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(decodedModel))
            } catch {
                print(error.localizedDescription)
                completionHandler(.failure(.mappingError))
            }
        }
        task.resume()
    }
    
    private func configureHeaders(for headers: [String: String], in request: inout URLRequest) {
        if let token = repository.apiToken {
            let bearerToken = "Bearer \(token)"
            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }

}
