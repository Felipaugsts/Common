//
//  ServiceProviderModel.swift
//  SDKCommon
//
//  Created by Felipe Augusto Silva on 06/09/23.
//

import Foundation
import UIKit

// MARK: - Enums

public enum RequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum APIError: Error {
    case badURL
    case requestFailed(statusCode: Int, reason: String, response: HTTPURLResponse?, data: Any?)
    case mappingError
    case tokenError
    case noConnection
    case customError(statusCode: Int, result: Any?)
    case unknown
}
