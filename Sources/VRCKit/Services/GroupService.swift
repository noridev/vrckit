//
//  GroupService.swift
//  VRCKit
//
//  Created by NoriDev on 7/13/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public final actor GroupService: APIService, GroupServiceProtocol {
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
    
    public func fetchGroup(groupId: String) async throws -> VRCGroup {
        let response = try await client.request(path: "groups/\(groupId)", method: .get)
        return try Serializer.shared.decode(response.data, httpResponse: response.response)
    }
    
    public func fetchGroupRawJSON(groupId: String) async throws -> Data {
        let response = try await client.request(path: "groups/\(groupId)", method: .get)
        return response.data
    }
}
