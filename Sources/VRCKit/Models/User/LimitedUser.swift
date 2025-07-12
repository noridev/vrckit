//
//  LimitedUserModel.swift
//  VRCKit
//
//  Created by NoriDev on 7/7/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct LimitedUser: Sendable, Identifiable, Hashable, ProfileElementRepresentable {
    public let bio: String?
    public var bioLinks: SafeDecodingArray<URL>
    public let avatarImageUrl: URL?
    public let avatarThumbnailUrl: URL?
    public let displayName: String
    public let id: String
    public let isFriend: Bool
    public let lastLogin: Date?
    public let lastActivity: Date?
    public let lastPlatform: String?
    public let platform: UserPlatform?
    public let profilePicOverride: URL?
    public let pronouns: String?
    public let status: UserStatus
    public let statusDescription: String
    public let tags: UserTags
    public let userIcon: URL?
    public let friendKey: String?

    public enum CodingKeys: String, CodingKey {
        case bio
        case bioLinks
        case avatarImageUrl = "currentAvatarImageUrl"
        case avatarThumbnailUrl = "currentAvatarThumbnailImageUrl"
        case displayName
        case id
        case isFriend
        case lastLogin
        case lastActivity
        case lastPlatform
        case platform
        case profilePicOverride
        case pronouns
        case status
        case statusDescription
        case tags
        case userIcon
        case friendKey
    }
}

extension LimitedUser: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        bioLinks = try container.decodeIfPresent(SafeDecodingArray<URL>.self, forKey: .bioLinks) ?? SafeDecodingArray()
        avatarImageUrl = try container.decodeIfPresent(URL.self, forKey: .avatarImageUrl)
        avatarThumbnailUrl = try container.decodeIfPresent(URL.self, forKey: .avatarThumbnailUrl)
        displayName = try container.decode(String.self, forKey: .displayName)
        id = try container.decode(String.self, forKey: .id)
        isFriend = try container.decode(Bool.self, forKey: .isFriend)
        let lastLoginString = try container.decodeIfPresent(String.self, forKey: .lastLogin)
        lastLogin = lastLoginString.flatMap { DateFormatter.iso8601Full.date(from: $0) }
        let lastActivityString = try container.decodeIfPresent(String.self, forKey: .lastActivity)
        lastActivity = lastActivityString.flatMap { DateFormatter.iso8601Full.date(from: $0) }
        lastPlatform = try container.decodeIfPresent(String.self, forKey: .lastPlatform)
        let platformString = try container.decodeIfPresent(String.self, forKey: .platform)
        platform = platformString.flatMap { UserPlatform(rawValue: $0) }
        let profilePicOverrideString = try container.decodeIfPresent(String.self, forKey: .profilePicOverride)
        profilePicOverride = profilePicOverrideString.flatMap { URL(string: $0) }
        pronouns = try container.decodeIfPresent(String.self, forKey: .pronouns)
        status = try container.decode(UserStatus.self, forKey: .status)
        statusDescription = try container.decode(String.self, forKey: .statusDescription)
        tags = try container.decode(UserTags.self, forKey: .tags)
        let userIconString = try container.decodeIfPresent(String.self, forKey: .userIcon)
        userIcon = userIconString.flatMap { URL(string: $0) }
        friendKey = try container.decodeIfPresent(String.self, forKey: .friendKey)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encode(bioLinks, forKey: .bioLinks)
        try container.encodeIfPresent(avatarImageUrl, forKey: .avatarImageUrl)
        try container.encodeIfPresent(avatarThumbnailUrl, forKey: .avatarThumbnailUrl)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(id, forKey: .id)
        try container.encode(isFriend, forKey: .isFriend)
        if let lastLogin = lastLogin {
            try container.encode(DateFormatter.iso8601Full.string(from: lastLogin), forKey: .lastLogin)
        }
        if let lastActivity = lastActivity {
            try container.encode(DateFormatter.iso8601Full.string(from: lastActivity), forKey: .lastActivity)
        }
        try container.encodeIfPresent(lastPlatform, forKey: .lastPlatform)
        try container.encodeIfPresent(platform, forKey: .platform)
        try container.encodeIfPresent(profilePicOverride, forKey: .profilePicOverride)
        try container.encodeIfPresent(pronouns, forKey: .pronouns)
        try container.encode(status, forKey: .status)
        try container.encode(statusDescription, forKey: .statusDescription)
        try container.encode(tags, forKey: .tags)
        try container.encodeIfPresent(userIcon, forKey: .userIcon)
        try container.encodeIfPresent(friendKey, forKey: .friendKey)
    }
}
