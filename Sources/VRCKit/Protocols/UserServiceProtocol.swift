//
//  UserServiceProtocol.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/14.
//

import Foundation

public protocol UserServiceProtocol: Sendable {
    /// Fetches detailed information about a specific user.
    /// - Parameter userId: The ID of the user to retrieve.
    /// - Returns: A `UserDetail` object containing detailed information about the specified user.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func fetchUser(userId: String) async throws -> UserDetail

    /// Fetches raw JSON data for a specific user from VRChat API.
    /// - Parameter userId: The ID of the user to retrieve.
    /// - Returns: Raw JSON data as Data from VRChat API.
    /// - Throws: An error if the request fails.
    func fetchUserRawJSON(userId: String) async throws -> Data

    /// Updates the information for a specific user.
    /// - Parameters:
    ///   - id: The ID of the user to update.
    ///   - editedInfo: An `EditableUserInfo` object containing the updated user information.
    /// - Throws: An error if the request fails or encoding is unsuccessful.
    func updateUser(id: String, editedInfo: EditableUserInfo) async throws

    /// Searches for users with the specified display name.
    /// - Parameter displayName: The display name of the user to search for.
    /// - Returns: An array of `LimitedUser` objects matching the search query.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func searchUser(displayName: String, n: Int, offset: Int) async throws -> [LimitedUser]
}
