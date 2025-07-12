//
//  UserService.swift
//  VRCKit
//
//  Created by makinosp on 2024/02/18.
//

import MemberwiseInit
import Foundation

@MemberwiseInit(.public)
public final actor UserService: APIService, UserServiceProtocol {
    public let client: APIClient
    private let path = "users"

    public func fetchUser(userId: String) async throws -> UserDetail {
        let response = try await client.request(path: "\(path)/\(userId)", method: .get)
        return try Serializer.shared.decode(response.data, httpResponse: response.response)
    }

    /// Fetches raw JSON data for a specific user from VRChat API.
    /// - Parameter userId: The ID of the user to retrieve.
    /// - Returns: Raw JSON data as Data from VRChat API.
    /// - Throws: An error if the request fails.
    public func fetchUserRawJSON(userId: String) async throws -> Data {
        let response = try await client.request(path: "\(path)/\(userId)", method: .get)
        return response.data
    }

    public func updateUser(id: String, editedInfo: EditableUserInfo) async throws {
        let requestData = try Serializer.shared.encode(editedInfo)
        let response = try await client.request(
            path: "\(path)/\(id)",
            method: .put,
            body: requestData
        )
        if response.response.statusCode >= 400 {
            let _: SuccessResponse = try Serializer.shared.decode(response.data, httpResponse: response.response)
        }
    }

    public func searchUser(displayName: String, n: Int = 100, offset: Int = 0) async throws -> [LimitedUser] {
        let queryItems = [
            URLQueryItem(name: "search", value: displayName),
            URLQueryItem(name: "n", value: String(n)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        let response = try await client.request(path: path, method: .get, queryItems: queryItems)
        return try Serializer.shared.decode(response.data, httpResponse: response.response)
    }
}
