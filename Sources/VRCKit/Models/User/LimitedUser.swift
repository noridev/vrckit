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
    public let lastPlatform: String?
    public let platform: UserPlatform?
    public let profilePicOverride: URL?
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
        case lastPlatform
        case platform
        case profilePicOverride
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
        lastPlatform = try container.decodeIfPresent(String.self, forKey: .lastPlatform)
        let platformString = try container.decodeIfPresent(String.self, forKey: .platform)
        platform = platformString.flatMap { UserPlatform(rawValue: $0) }
        let profilePicOverrideString = try container.decodeIfPresent(String.self, forKey: .profilePicOverride)
        profilePicOverride = profilePicOverrideString.flatMap { URL(string: $0) }
        status = try container.decode(UserStatus.self, forKey: .status)
        statusDescription = try container.decode(String.self, forKey: .statusDescription)
        tags = try container.decode(UserTags.self, forKey: .tags)
        let userIconString = try container.decodeIfPresent(String.self, forKey: .userIcon)
        userIcon = userIconString.flatMap { URL(string: $0) }
        friendKey = try container.decodeIfPresent(String.self, forKey: .friendKey)
    }
}
