//
//  GroupModel+Encodable.swift
//  VRCKit
//
//  Created by NoriDev on 7/17/25.
//

import Foundation

extension VRCGroup: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encodeIfPresent(groupId, forKey: .groupId)
        try container.encode(name, forKey: .name)
        try container.encode(shortCode, forKey: .shortCode)
        try container.encode(discriminator, forKey: .discriminator)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(bannerId, forKey: .bannerId)
        try container.encodeIfPresent(bannerUrl, forKey: .bannerUrl)
        try container.encodeIfPresent(iconId, forKey: .iconId)
        try container.encodeIfPresent(iconUrl, forKey: .iconUrl)
        try container.encode(ownerId, forKey: .ownerId)
        try container.encode(privacy, forKey: .privacy)
        try container.encode(memberCount, forKey: .memberCount)
        try container.encodeIfPresent(onlineMemberCount, forKey: .onlineMemberCount)
        try container.encode(memberVisibility, forKey: .memberVisibility)
        try container.encode(mutualGroup, forKey: .mutualGroup)
        try container.encode(isRepresenting, forKey: .isRepresenting)
        try container.encodeIfPresent(lastPostCreatedAt, forKey: .lastPostCreatedAt)
        try container.encodeIfPresent(lastPostReadAt, forKey: .lastPostReadAt)
        try container.encodeIfPresent(rules, forKey: .rules)
        try container.encodeIfPresent(isVerified, forKey: .isVerified)
        try container.encodeIfPresent(joinState, forKey: .joinState)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(languages, forKey: .languages)
        try container.encodeIfPresent(links, forKey: .links)
        try container.encodeIfPresent(galleries, forKey: .galleries)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encodeIfPresent(memberships, forKey: .memberships)
        try container.encodeIfPresent(roles, forKey: .roles)
        try container.encodeIfPresent(representable, forKey: .representable)
        try container.encodeIfPresent(myMember, forKey: .myMember)
    }
}
