//
//  GroupModel.swift
//  VRCKit
//
//  Created by NoriDev on 7/13/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct VRCGroup: Sendable, Identifiable {
    public let id: String // This is the membership ID (gmem_...) or group ID (grp_...) in detail view
    public let groupId: String? // This is the actual group ID (grp_...), optional for detail view
    public let name: String
    public let shortCode: String
    public let discriminator: String
    public let description: String?
    public let bannerId: String?
    public let bannerUrl: URL?
    public let iconId: String?
    public let iconUrl: URL?
    public let onlineMemberCount: Int?
    public let ownerId: String
    public let privacy: GroupPrivacy
    public let memberCount: Int
    public let memberVisibility: GroupMembershipVisibility
    public let mutualGroup: Bool
    public let isRepresenting: Bool
    public let lastPostCreatedAt: Date?
    public let lastPostReadAt: Date?
    public let rules: String?
    public let isVerified: Bool?
    public let joinState: GroupJoinState?
    public let tags: [String]?
    public let languages: [String]?
    public let galleries: [GroupGallery]?
    public let createdAt: Date?
    public let updatedAt: Date?
    public let memberships: [GroupMembership]?
    public let roles: [GroupRole]?
    public let representable: Bool?
    public let myMember: GroupMembership?
    
    enum CodingKeys: String, CodingKey {
        case id, groupId, name, shortCode, discriminator, description
        case bannerId, bannerUrl, iconId, iconUrl, ownerId, privacy
        case memberCount, onlineMemberCount, memberVisibility, mutualGroup, isRepresenting
        case lastPostCreatedAt, lastPostReadAt, rules, isVerified
        case joinState, tags, languages, galleries, createdAt, updatedAt
        case memberships, roles, representable, myMember
    }
    
    public var languageTags: [LanguageTag] {
        guard let languages = languages else { return [] }
        
        return languages.compactMap { langString -> LanguageTag? in
            let rawValue = "language_\(langString.prefix(3).lowercased())"
            return LanguageTag(rawValue: rawValue)
        }
    }
}

@MemberwiseInit(.public)
public struct GroupGallery: Codable, Sendable, Identifiable {
    public let id: String
    public let name: String
    public let description: String?
    public let membersOnly: Bool
    public let roleIdsToView: [String]?
    public let roleIdsToSubmit: [String]?
    public let roleIdsToAutoApprove: [String]?
    public let roleIdsToManage: [String]?
    public let createdAt: Date?
    public let updatedAt: Date?
}

public struct GroupMembership: Codable, Sendable {
    public let id: String
    public let groupId: String
    public let userId: String
    public let isRepresenting: Bool
    public let isSubscribedToAnnouncements: Bool
    public let visibility: GroupMembershipVisibility
    public let isSubscribedToEvents: Bool
    public let roleIds: [String]
    public let joinedAt: Date?
    public let rolePermissions: [String]?
    public let roleOrder: [String]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        print("🔍 [GroupMembership] Starting to decode GroupMembership")
        
        if let idValue = try? container.decode(String.self, forKey: .id) {
            id = idValue
            print("✅ [GroupMembership] Successfully decoded id: \(idValue)")
        } else {
            id = "default_member_id"
            print("⚠️ [GroupMembership] Failed to decode id, using default")
        }
        
        if let groupIdValue = try? container.decode(String.self, forKey: .groupId) {
            groupId = groupIdValue
            print("✅ [GroupMembership] Successfully decoded groupId: \(groupIdValue)")
        } else {
            groupId = "default_group_id"
            print("⚠️ [GroupMembership] Failed to decode groupId, using default")
        }
        
        if let userIdValue = try? container.decode(String.self, forKey: .userId) {
            userId = userIdValue
            print("✅ [GroupMembership] Successfully decoded userId: \(userIdValue)")
        } else {
            userId = "default_user_id"
            print("⚠️ [GroupMembership] Failed to decode userId, using default")
        }
        
        if let isRepresentingValue = try? container.decode(Bool.self, forKey: .isRepresenting) {
            isRepresenting = isRepresentingValue
            print("✅ [GroupMembership] Successfully decoded isRepresenting: \(isRepresentingValue)")
        } else {
            isRepresenting = false
            print("⚠️ [GroupMembership] Failed to decode isRepresenting, using default: false")
        }
        
        if let isSubscribedToAnnouncementsValue = try? container.decode(Bool.self, forKey: .isSubscribedToAnnouncements) {
            isSubscribedToAnnouncements = isSubscribedToAnnouncementsValue
            print("✅ [GroupMembership] Successfully decoded isSubscribedToAnnouncements: \(isSubscribedToAnnouncementsValue)")
        } else {
            isSubscribedToAnnouncements = true
            print("⚠️ [GroupMembership] Failed to decode isSubscribedToAnnouncements, using default: true")
        }
        
        if let isSubscribedToEventsValue = try? container.decode(Bool.self, forKey: .isSubscribedToEvents) {
            isSubscribedToEvents = isSubscribedToEventsValue
            print("✅ [GroupMembership] Successfully decoded isSubscribedToEvents: \(isSubscribedToEventsValue)")
        } else {
            isSubscribedToEvents = true
            print("⚠️ [GroupMembership] Failed to decode isSubscribedToEvents, using default: true")
        }
        
        if let visibilityValue = try? container.decode(GroupMembershipVisibility.self, forKey: .visibility) {
            visibility = visibilityValue
            print("✅ [GroupMembership] Successfully decoded visibility: \(visibilityValue)")
        } else {
            visibility = .visible
            print("⚠️ [GroupMembership] Failed to decode visibility, using default: .visible")
        }
        
        if let roleIdsValue = try? container.decode([String].self, forKey: .roleIds) {
            roleIds = roleIdsValue
            print("✅ [GroupMembership] Successfully decoded roleIds: \(roleIdsValue)")
        } else {
            roleIds = []
            print("⚠️ [GroupMembership] Failed to decode roleIds, using default: []")
        }
        
        if let joinedAtString = try? container.decode(String.self, forKey: .joinedAt) {
            joinedAt = DateFormatter.iso8601Full.date(from: joinedAtString)
            print("✅ [GroupMembership] Successfully decoded joinedAt from string: \(joinedAtString) -> \(joinedAt?.description ?? "nil")")
        } else if let joinedAtValue = try? container.decode(Date.self, forKey: .joinedAt) {
            joinedAt = joinedAtValue
            print("✅ [GroupMembership] Successfully decoded joinedAt as Date: \(joinedAtValue)")
        } else {
            joinedAt = nil
            print("⚠️ [GroupMembership] Failed to decode joinedAt, using default: nil")
        }
        
        rolePermissions = try container.decodeIfPresent([String].self, forKey: .rolePermissions)
        roleOrder = try container.decodeIfPresent([String].self, forKey: .roleOrder)
        
        print("✅ [GroupMembership] Completed decoding GroupMembership")
    }
    
    public init(
        id: String,
        groupId: String,
        userId: String,
        isRepresenting: Bool,
        isSubscribedToAnnouncements: Bool,
        visibility: GroupMembershipVisibility,
        isSubscribedToEvents: Bool,
        roleIds: [String],
        joinedAt: Date?,
        rolePermissions: [String]?,
        roleOrder: [String]?
    ) {
        self.id = id
        self.groupId = groupId
        self.userId = userId
        self.isRepresenting = isRepresenting
        self.isSubscribedToAnnouncements = isSubscribedToAnnouncements
        self.visibility = visibility
        self.isSubscribedToEvents = isSubscribedToEvents
        self.roleIds = roleIds
        self.joinedAt = joinedAt
        self.rolePermissions = rolePermissions
        self.roleOrder = roleOrder
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, groupId, userId, isRepresenting, isSubscribedToAnnouncements
        case visibility, isSubscribedToEvents, roleIds, joinedAt, rolePermissions, roleOrder
    }
}

@MemberwiseInit(.public)
public struct GroupRole: Codable, Sendable, Identifiable {
    public let id: String
    public let groupId: String
    public let name: String
    public let description: String?
    public let isSelfAssignable: Bool
    public let permissions: [String]
    public let isManagementRole: Bool
    public let requiresTwoFactor: Bool
    public let requiresPurchase: Bool
    public let order: Int
    public let createdAt: Date?
    public let updatedAt: Date?
}

public enum GroupPrivacy: String, Codable, Sendable {
    case `private` = "private"
    case `public` = "public"
    case `default` = "default"
    case unknown

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = GroupPrivacy(rawValue: value) ?? .unknown
    }
}

public enum GroupJoinState: String, Codable, Sendable {
    case closed = "closed"
    case invite = "invite"
    case request = "request"
    case open = "open"
}

public enum GroupMembershipVisibility: String, Codable, Sendable {
    case visible = "visible"
    case hidden = "hidden"
    case friends = "friends"
}

extension VRCGroup {
    public var isOwner: Bool {
        false
    }
    
    public var canManage: Bool {
        guard let memberships = memberships else { return false }
        return memberships.contains { membership in
            membership.roleIds.contains { roleId in
                roles?.contains { role in
                    role.id == roleId && role.isManagementRole
                } ?? false
            }
        }
    }
    
    public var actualGroupId: String {
        return groupId ?? id
    }
}

extension GroupMembership {
    public var isManager: Bool {
        roleIds.contains { roleId in
            false
        }
    }
}
