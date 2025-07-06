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
        return try Serializer.shared.decode(response.data)
    }

    public func updateUser(id: String, editedInfo: EditableUserInfo) async throws {
        let requestData = try Serializer.shared.encode(editedInfo)
        _ = try await client.request(
            path: "\(path)/\(id)",
            method: .put,
            body: requestData
        )
    }

    public func searchUser(displayName: String, n: Int = 100, offset: Int = 0) async throws -> [LimitedUser] {
        let queryItems = [
            URLQueryItem(name: "search", value: displayName),
            URLQueryItem(name: "n", value: String(n)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        let response = try await client.request(path: path, method: .get, queryItems: queryItems)
        return try Serializer.shared.decode(response.data)
    }
}
