//
//  HTTPRequestProtocol.swift
//  FBSnapshotTestCase
//
//  Created by FELIPE AUGUSTO SILVA on 18/11/22.
//

import Foundation

public protocol HTTPRequestProtocol {
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T,Error>) -> Void)
}

public class DefaultHTTPRequest: HTTPRequestProtocol {

    /// <#Description#>
    /// - Parameters:
    ///   - urlString: API URL that will be fetched
    ///   - completion: Returned value after trying to fetch the API
    public func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T,Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in

            if let error = error {
                completion(.failure(error)); return
            }
            guard let data = data else { return }
            completion( Result{ try JSONDecoder().decode(T.self, from: data) })
        }.resume()
    }
}
