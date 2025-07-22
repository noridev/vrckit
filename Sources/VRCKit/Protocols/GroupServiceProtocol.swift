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
    func fetchGroup(groupId: String, includeRoles: Bool, includeMembers: Bool) async throws -> VRCGroup

    /// Fetches a list of all members in a specific group.
    /// - Parameter groupId: The ID of the group to retrieve members from.
    /// - Returns: An array of `GroupMembership` objects representing the members of the group.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func fetchGroupMembers(groupId: String) async throws -> [GroupMembership]
    
    /// Fetches a list of posts in a specific group.
    /// - Parameter groupId: The ID of the group to retrieve posts from.
    /// - Returns: An array of `GroupPost` objects representing the posts of the group.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func fetchGroupPosts(groupId: String) async throws -> [GroupPost]
    
    /// Fetches all images from a specific group gallery.
    /// - Parameters:
    ///   - groupId: The ID of the group.
    ///   - galleryId: The ID of the gallery.
    /// - Returns: An array of `GroupGalleryImage` objects.
    /// - Throws: An error if the request fails or decoding is unsuccessful.
    func fetchGroupGalleryImages(groupId: String, galleryId: String) async throws -> [GroupGalleryImage]
    
    /// Fetches raw JSON data for a specific group.
    /// - Parameter groupId: The ID of the group to retrieve raw JSON for.
    /// - Returns: Raw JSON data as `Data`.
    /// - Throws: An error if the request fails.
    func fetchGroupRawJSON(groupId: String) async throws -> Data
}
