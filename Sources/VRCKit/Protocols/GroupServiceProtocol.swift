//
//  GroupServiceProtocol.swift
//  VRCKit
//
//  Created by NoriDev on 7/13/25.
//

import Foundation

public protocol GroupServiceProtocol: Sendable {
    /// Fetches all groups that a user is a member of.
    /// - Parameter userId: The ID of the user to get groups for.
    /// - Returns: An array of `VRCGroup` objects representing the user's groups.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func fetchUserGroups(userId: String) async throws -> [VRCGroup]
    
    /// Fetches groups that a user is representing.
    /// - Parameter userId: The ID of the user to get represented groups for.
    /// - Returns: An array of `VRCGroup` objects representing the groups the user is representing.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func fetchUserRepresentedGroups(userId: String) async throws -> [VRCGroup]
    
    /// Fetches detailed information about a specific group.
    /// - Parameter groupId: The ID of the group to retrieve.
    /// - Returns: A `VRCGroup` object containing detailed information about the specified group.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func fetchGroup(groupId: String) async throws -> VRCGroup
    
    /// Fetches raw JSON data for a specific group.
    /// - Parameter groupId: The ID of the group to retrieve raw JSON for.
    /// - Returns: Raw JSON data as `Data`.
    /// - Throws: An error if the request fails.
    func fetchGroupRawJSON(groupId: String) async throws -> Data
}
