//
//  FriendModel+Encodable.swift
//  VRCKit
//
//  Created by NoriDev on 7/5/25.
//

import Foundation

extension Friend {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: UserCodingKeys.self)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encode(bioLinks, forKey: .bioLinks)
        try container.encodeIfPresent(avatarImageUrl, forKey: .currentAvatarImageUrl)
        try container.encodeIfPresent(avatarThumbnailUrl, forKey: .currentAvatarThumbnailImageUrl)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(id, forKey: .id)
        try container.encode(isFriend, forKey: .isFriend)
        try container.encode(lastLogin, forKey: .lastLogin)
        try container.encode(lastPlatform, forKey: .lastPlatform)
        try container.encode(platform, forKey: .platform)
        try container.encodeIfPresent(profilePicOverride, forKey: .profilePicOverride)
        try container.encode(status, forKey: .status)
        try container.encode(statusDescription, forKey: .statusDescription)
        try container.encode(tags, forKey: .tags)
        try container.encodeIfPresent(userIcon, forKey: .userIcon)
        try container.encode(location, forKey: .location)
        try container.encode(friendKey, forKey: .friendKey)
    }
}
