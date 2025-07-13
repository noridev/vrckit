//
//  UserDetailModel.swift
//  VRCKit
//
//  Created by makinosp on 2024/03/17.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct UserDetail: Sendable, ProfileDetailRepresentable, LocationRepresentable, Encodable {
    public let ageVerificationStatus: AgeVerificationStatus
    public let ageVerified: Bool
    public let badges: [Badge]
    public var bio: String?
    public var bioLinks: SafeDecodingArray<URL>
    public let avatarImageUrl: URL?
    public let avatarThumbnailUrl: URL?
    public let displayName: String
    public let id: String
    public let isFriend: Bool
    public let lastLogin: Date?
    public let lastPlatform: String?
    public let profilePicOverride: URL?
    public let pronouns: String?
    public let state: User.State
    public let status: UserStatus
    public var statusDescription: String
    public var tags: UserTags
    public let userIcon: URL?
    public let location: Location
    public let friendKey: String?
    public let dateJoined: Date?
    public var note: String
    public let lastActivity: Date?
    public let platform: UserPlatform?
}

public extension UserDetail {
    var url: URL? {
        URL(string: [Const.homeBaseUrl, "user", id].joined(separator: "/"))
    }
}

extension UserDetail {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: UserCodingKeys.self)
        try container.encode(ageVerificationStatus, forKey: .ageVerificationStatus)
        try container.encode(ageVerified, forKey: .ageVerified)
        try container.encodeIfPresent(badges, forKey: .badges)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encode(bioLinks.wrappedValue, forKey: .bioLinks)
        try container.encodeIfPresent(avatarImageUrl, forKey: .currentAvatarImageUrl)
        try container.encodeIfPresent(avatarThumbnailUrl, forKey: .currentAvatarThumbnailImageUrl)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(id, forKey: .id)
        try container.encode(isFriend, forKey: .isFriend)
        if let lastLogin = lastLogin {
            try container.encode(DateFormatter.iso8601Full.string(from: lastLogin), forKey: .lastLogin)
        }
        try container.encodeIfPresent(lastPlatform, forKey: .lastPlatform)
        try container.encodeIfPresent(profilePicOverride, forKey: .profilePicOverride)
        try container.encodeIfPresent(pronouns, forKey: .pronouns)
        try container.encode(state, forKey: .state)
        try container.encode(status, forKey: .status)
        try container.encode(statusDescription, forKey: .statusDescription)
        try container.encode(tags, forKey: .tags)
        try container.encodeIfPresent(userIcon, forKey: .userIcon)
        try container.encode(location, forKey: .location)
        try container.encodeIfPresent(friendKey, forKey: .friendKey)
        if let dateJoined = dateJoined {
            try container.encode(DateFormatter.dateStringFormat.string(from: dateJoined), forKey: .dateJoined)
        }
        try container.encode(note, forKey: .note)
        if let lastActivity = lastActivity {
            try container.encode(DateFormatter.iso8601Full.string(from: lastActivity), forKey: .lastActivity)
        }
        try container.encodeIfPresent(platform, forKey: .platform)
    }
}
