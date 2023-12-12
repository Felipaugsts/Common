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
    case invalidResponse
    case invalidData
    case badURL, requestFailed(_ statusCode: Int, _ reason: String, _ response: HTTPURLResponse?, _ data: Any?), mappingError, tokenError, noConnection, customError(statusCode: Int, result: Any?), unknown
}
