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
        case memberCount, memberVisibility, mutualGroup, isRepresenting
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

@MemberwiseInit(.public)
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
