//
//  Friend+Decodable.swift
//  VRCKit
//
//  Created by makinosp on 2024/09/02.
//

import Foundation

extension Friend {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        ageVerificationStatus = try container.decodeIfPresent(AgeVerificationStatus.self, forKey: .ageVerificationStatus)
        ageVerified = try container.decodeIfPresent(Bool.self, forKey: .ageVerified)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        bioLinks = try container.decodeSafeNullableArray(URL.self, forKey: .bioLinks)
        avatarImageUrl = try container.decodeIfPresent(URL.self, forKey: .currentAvatarImageUrl)
        avatarThumbnailUrl = try container.decodeIfPresent(URL.self, forKey: .currentAvatarThumbnailImageUrl)
        displayName = try container.decode(String.self, forKey: .displayName)
        id = try container.decode(Friend.ID.self, forKey: .id)
        isFriend = try container.decode(Bool.self, forKey: .isFriend)
        let lastLoginString = try container.decodeIfPresent(String.self, forKey: .lastLogin)
        lastLogin = lastLoginString.flatMap { DateFormatter.iso8601Full.date(from: $0) }
        lastPlatform = try container.decodeIfPresent(String.self, forKey: .lastPlatform)
        let profilePicOverrideString = try container.decodeIfPresent(String.self, forKey: .profilePicOverride)
        profilePicOverride = profilePicOverrideString.flatMap { URL(string: $0) }
        status = try container.decode(UserStatus.self, forKey: .status)
        statusDescription = try container.decode(String.self, forKey: .statusDescription)
        tags = try container.decode(UserTags.self, forKey: .tags)
        let userIconString = try container.decodeIfPresent(String.self, forKey: .userIcon)
        userIcon = userIconString.flatMap { URL(string: $0) }
        location = try container.decode(Location.self, forKey: .location)
        friendKey = try container.decodeIfPresent(String.self, forKey: .friendKey)
        let platformString = try container.decodeIfPresent(String.self, forKey: .platform)
        platform = platformString.flatMap { UserPlatform(rawValue: $0) }
    }
}
