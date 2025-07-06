//
//  UserModel+Decodable.swift
//  VRCKit
//
//  Created by makinosp on 2024/09/02.
//

import Foundation

extension User: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: UserCodingKeys.self)
        ageVerificationStatus = try container.decode(AgeVerificationStatus.self, forKey: .ageVerificationStatus)
        ageVerified = try container.decode(Bool.self, forKey: .ageVerified)
        activeFriends = try container.decode([String].self, forKey: .activeFriends)
        allowAvatarCopying = try container.decode(Bool.self, forKey: .allowAvatarCopying)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        bioLinks = try container.decodeSafeNullableArray(URL.self, forKey: .bioLinks)
        currentAvatar = try container.decode(String.self, forKey: .currentAvatar)
        avatarImageUrl = try? container.decodeIfPresent(URL.self, forKey: .currentAvatarImageUrl)
        avatarThumbnailUrl = try? container.decodeIfPresent(URL.self, forKey: .currentAvatarThumbnailImageUrl)
        let dateJoinedString = try container.decode(String.self, forKey: .dateJoined)
        dateJoined = DateFormatter.dateStringFormat.date(from: dateJoinedString)
        displayName = try container.decode(String.self, forKey: .displayName)
        friendKey = try container.decodeIfPresent(String.self, forKey: .friendKey)
        friends = try container.decode([String].self, forKey: .friends)
        homeLocation = try container.decode(String.self, forKey: .homeLocation)
        id = try container.decode(User.ID.self, forKey: .id)
        isFriend = try container.decode(Bool.self, forKey: .isFriend)
        let lastActivityString = try container.decodeIfPresent(String.self, forKey: .lastActivity)
        lastActivity = lastActivityString.flatMap { DateFormatter.iso8601Full.date(from: $0) }
        let lastLoginString = try container.decodeIfPresent(String.self, forKey: .lastLogin)
        lastLogin = lastLoginString.flatMap { DateFormatter.iso8601Full.date(from: $0) }
        lastPlatform = try container.decodeIfPresent(String.self, forKey: .lastPlatform)
        offlineFriends = try container.decode([String].self, forKey: .offlineFriends)
        onlineFriends = try container.decode([String].self, forKey: .onlineFriends)
        pastDisplayNames = try container.decode([DisplayName].self, forKey: .pastDisplayNames)
        let profilePicOverrideString = try container.decodeIfPresent(String.self, forKey: .profilePicOverride)
        profilePicOverride = profilePicOverrideString.flatMap { URL(string: $0) }
        state = try container.decode(User.State.self, forKey: .state)
        status = try container.decode(UserStatus.self, forKey: .status)
        statusDescription = try container.decode(String.self, forKey: .statusDescription)
        tags = try container.decode(UserTags.self, forKey: .tags)
        twoFactorAuthEnabled = try container.decode(Bool.self, forKey: .twoFactorAuthEnabled)
        let userIconString = try container.decodeIfPresent(String.self, forKey: .userIcon)
        userIcon = userIconString.flatMap { URL(string: $0) }
        userLanguage = try container.decodeIfPresent(String.self, forKey: .userLanguage)
        userLanguageCode = try container.decodeIfPresent(String.self, forKey: .userLanguageCode)
        presence = try container.decode(Presence.self, forKey: .presence)
        let platformString = try container.decodeIfPresent(String.self, forKey: .platform)
        platform = platformString.flatMap { UserPlatform(rawValue: $0) }
    }
}
