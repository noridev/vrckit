//
//  Serializer.swift
//  VRCKit
//
//  Created by makinosp on 2024/03/10.
//

import Foundation

final class Serializer: Sendable {
    static let shared = Serializer()
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    /// Initializes the `Util` class, setting up custom encoding and decoding strategies.
    private init() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.iso8601Full)
        self.encoder = encoder
    }

    /// Decodes JSON data into a specified `Decodable` type.
    /// - Parameter data: The JSON data to decode.
    /// - Throws: 
    ///   - `VRCKitError.unauthorized` if the decoded data contains an unauthentized error.
    ///   - `VRCKitError.apiError` if the decoded data contains an API error.
    ///   - `DecodingError` if the decoding process fails.
    /// - Returns: The decoded object of type `T`.
    func decode<T>(_ data: Data) throws -> T where T: Decodable {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let key, let context):
                print("Error: Key '\(key.stringValue)' not found at codingPath: \(context.codingPath)")
            case .valueNotFound(let type, let context):
                print("Error: Value of type '\(type)' not found at codingPath: \(context.codingPath)")
            case .typeMismatch(let type, let context):
                print("Error: Type '\(type)' mismatch at codingPath: \(context.codingPath)")
            case .dataCorrupted(let context):
                print("Error: Data corrupted at codingPath: \(context.codingPath)")
            @unknown default:
                print("An unknown decoding error occurred: \(error.localizedDescription)")
            }

            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                let statusCode = errorResponse.error.statusCode
                let message = errorResponse.error.message
                
                switch statusCode {
                case 401:
                    throw VRCKitError.unauthorized(context: .sessionExpired(statusCode: statusCode, message: message))
                case 500...599:
                    throw VRCKitError.serverError(statusCode: statusCode, message: message)
                default:
                    throw VRCKitError.apiError(message)
                }
            } catch _ as DecodingError {
                throw error
            }
        }
    }

    /// Decodes JSON data with HTTP response context for better error handling.
    /// - Parameters:
    ///   - data: The JSON data to decode.
    ///   - httpResponse: The HTTP response containing status code and headers.
    ///   - isLoginAttempt: Whether this is a login attempt (for context-aware error handling).
    /// - Returns: The decoded object of type `T`.
    func decode<T>(_ data: Data, httpResponse: HTTPURLResponse, isLoginAttempt: Bool = false) throws -> T where T: Decodable {
        do {
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let key, let context):
                print("Error: Key '\(key.stringValue)' not found at codingPath: \(context.codingPath)")
            case .valueNotFound(let type, let context):
                print("Error: Value of type '\(type)' not found at codingPath: \(context.codingPath)")
            case .typeMismatch(let type, let context):
                print("Error: Type '\(type)' mismatch at codingPath: \(context.codingPath)")
            case .dataCorrupted(let context):
                print("Error: Data corrupted at codingPath: \(context.codingPath)")
            @unknown default:
                print("An unknown decoding error occurred: \(error.localizedDescription)")
            }

            let statusCode = httpResponse.statusCode
            print("HTTP Status Code: \(statusCode)")
            
            var errorMessage = "Unknown error"
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                errorMessage = errorResponse.error.message
            } else if let responseString = String(data: data, encoding: .utf8) {
                errorMessage = responseString
            }
            
            switch statusCode {
            case 401:
                let context: UnauthorizedContext = isLoginAttempt 
                    ? .loginFailed(statusCode: statusCode, message: errorMessage)
                    : .sessionExpired(statusCode: statusCode, message: errorMessage)
                throw VRCKitError.unauthorized(context: context)
            case 400...499:
                throw VRCKitError.apiError("Client Error (\(statusCode)): \(errorMessage)")
            case 500...599:
                throw VRCKitError.serverError(statusCode: statusCode, message: errorMessage)
            default:
                throw VRCKitError.apiError("HTTP Error (\(statusCode)): \(errorMessage)")
            }
        }
    }

    /// Encodes an `Encodable` object into JSON data.
    /// - Parameter data: The object to encode.
    /// - Throws: An error if the encoding process fails.
    /// - Returns: The encoded JSON data.
    func encode(_ data: Encodable) throws -> Data {
        try encoder.encode(data)
    }
}
