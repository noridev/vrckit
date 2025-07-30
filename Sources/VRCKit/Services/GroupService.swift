//
//  GroupService.swift
//  VRCKit
//
//  Created by NoriDev on 7/13/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public final actor GroupService: APIService, GroupProvidable {
    public let client: APIClient
    private let path = "users"

    public func fetchUserGroups(userId: String) async throws -> [VRCGroup] {
        let response = try await client.request(path: "\(path)/\(userId)/groups", method: .get)
        
        if let jsonString = String(data: response.data, encoding: .utf8) {
            print("🔍 [GroupService] Raw response: \(jsonString)")
        }
        
        do {
            return try Serializer.shared.decode(response.data, httpResponse: response.response)
        } catch {
            print("⚠️ [GroupService] Failed to decode groups as array: \(error)")
            return []
        }
    }
    
    public func fetchUserRepresentedGroups(userId: String) async throws -> [VRCGroup] {
        let response = try await client.request(path: "\(path)/\(userId)/groups/represented", method: .get)
        
        if let jsonString = String(data: response.data, encoding: .utf8) {
            print("🔍 [GroupService] Raw represented response: \(jsonString)")
        }
        
        if let jsonString = String(data: response.data, encoding: .utf8),
           jsonString.trimmingCharacters(in: .whitespacesAndNewlines) == "{}" {
            print("ℹ️ [GroupService] Empty represented groups response, returning empty array")
            return []
        }
        
        do {
            let group = try Serializer.shared.decode(response.data, httpResponse: response.response) as VRCGroup
            return [group]
        } catch {
            print("⚠️ [GroupService] Failed to decode represented group: \(error)")
            return []
        }
    }
    
    public func fetchGroup(groupId: String, includeRoles: Bool = true, includeMembers: Bool = true) async throws -> VRCGroup {
        var queryItems: [URLQueryItem] = []
        
        if includeRoles {
            queryItems.append(URLQueryItem(name: "includeRoles", value: "true"))
        }
        
        if includeMembers {
            queryItems.append(URLQueryItem(name: "includeMembers", value: "true"))
        }
        
        let response = try await client.request(path: "groups/\(groupId)", method: .get, queryItems: queryItems)
        return try Serializer.shared.decode(response.data, httpResponse: response.response)
    }
    
    public func fetchGroupMembers(groupId: String, offset: Int, n: Int) async throws -> [GroupMembership] {
        let queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "n", value: String(n))
        ]
        let response = try await client.request(
            path: "groups/\(groupId)/members",
            method: .get,
            queryItems: queryItems
        )
        return try Serializer.shared.decode(response.data, httpResponse: response.response)
    }
    
    public func fetchGroupPosts(groupId: String) async throws -> [GroupPost] {
        let response = try await client.request(path: "groups/\(groupId)/posts", method: .get)
        
        // Parse the response as { "posts": [...] }
        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        guard let postsData = json?["posts"] else {
            throw VRCKitError.invalidResponse("No 'posts' key found in response")
        }
        
        let postsJsonData = try JSONSerialization.data(withJSONObject: postsData)
        return try Serializer.shared.decode(postsJsonData, httpResponse: response.response)
    }
    
    public func fetchGroupGalleryImages(groupId: String, galleryId: String) async throws -> [GroupGalleryImage] {
        let response = try await client.request(path: "groups/\(groupId)/galleries/\(galleryId)", method: .get)
        return try Serializer.shared.decode(response.data, httpResponse: response.response)
    }
    
    public func fetchGroupRawJSON(groupId: String) async throws -> Data {
        let response = try await client.request(path: "groups/\(groupId)", method: .get)
        return response.data
    }
    
    public func fetchGroupInstances(userId: String, groupId: String) async throws -> [Instance] {
        let response = try await client.request(
            path: "users/\(userId)/instances/groups/\(groupId)",
            method: .get
        )
        if let jsonString = String(data: response.data, encoding: .utf8) {
            print("🔍 [fetchGroupInstances] Raw response: \(jsonString)")
        }
        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]
        guard let instancesData = json?["instances"] else {
            throw VRCKitError.invalidResponse("No 'instances' key found in response")
        }
        let instancesJsonData = try JSONSerialization.data(withJSONObject: instancesData)
        return try Serializer.shared.decode(instancesJsonData)
    }
}
