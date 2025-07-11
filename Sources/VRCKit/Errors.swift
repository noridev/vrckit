//
//  Errors.swift
//  VRCKit
//
//  Created by makinosp on 2024/04/28.
//

import Foundation

/// An enumeration that represents various errors that can occur in the VRCKit framework.
/// Conforms to the `Error` and `LocalizedError` protocols for better error handling and localization.
public enum VRCKitError: Error, LocalizedError, Equatable {
    private typealias RawValue = String

    /// Represents an error from the API with details.
    case apiError(_ details: String)

    /// Represents a bad gatewaty error.
    case badGateway

    /// Represents an error indicating that the client has been deallocated.
    case clientDeallocated

    /// Represents an error indicating that credential not set.
    case credentialNotSet

    /// Represents an error indicating an invalid response was received.
    case invalidResponse(_ details: String)

    /// Represents an error indicating an invalid request with additional details.
    case invalidRequest(_ details: String)

    /// Represents an error indicating an authentication failure with context.
    case unauthorized(context: UnauthorizedContext)

    /// Represents an url error.
    case urlError

    /// Represents network connectivity issues.
    case networkError(_ details: String)

    /// Represents server errors (5xx status codes).
    case serverError(statusCode: Int, message: String)

    /// Provides a localized description of the error.
    public var errorDescription: String? {
        switch self {
        case .apiError: "API Error"
        case .badGateway: "Bad Gateway"
        case .clientDeallocated: "Client Deallocated"
        case .credentialNotSet: "Credential Error"
        case .invalidResponse: "Invalid Response"
        case .invalidRequest: "Invalid Request"
        case .unauthorized: "Unauthorized"
        case .urlError: "URL Error"
        case .networkError: "Network Error"
        case .serverError: "Server Error"
        }
    }

    /// Provides a localized failure reason for the error.
    public var failureReason: String? {
        switch self {
        case .apiError(let details): details
        case .invalidRequest(let details): details
        case .invalidResponse(let details): details
        case .unauthorized(let context): context.localizedDescription
        case .networkError(let details): details
        case .serverError(let statusCode, let message): "Server Error (\(statusCode)): \(message)"
        default: errorDescription
        }
    }
}

/// Context information for unauthorized errors
public enum UnauthorizedContext: Equatable {
    case loginFailed(statusCode: Int, message: String)
    case sessionExpired(statusCode: Int, message: String)
    
    public var localizedDescription: String {
        switch self {
        case .loginFailed(let statusCode, let message):
            return "Login failed (\(statusCode)): \(message)"
        case .sessionExpired(let statusCode, let message):
            return "Session expired (\(statusCode)): \(message)"
        }
    }
    
    public var isLoginFailure: Bool {
        switch self {
        case .loginFailed: return true
        case .sessionExpired: return false
        }
    }
}
