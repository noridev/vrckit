//
//  GroupModel+Decodable.swift
//  VRCKit
//
//  Created by NoriDev on 7/17/25.
//

import Foundation

extension VRCGroup: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let idValue = try? container.decode(String.self, forKey: .id) {
            id = idValue
        } else {
            id = try container.decode(String.self, forKey: .groupId)
        }
        
        if let groupIdValue = try? container.decode(String.self, forKey: .groupId) {
            groupId = groupIdValue
        } else {
            groupId = id
        }
        
        name = try container.decode(String.self, forKey: .name)
        shortCode = try container.decode(String.self, forKey: .shortCode)
        discriminator = try container.decode(String.self, forKey: .discriminator)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        bannerId = try container.decodeIfPresent(String.self, forKey: .bannerId)
        bannerUrl = try container.decodeIfPresent(URL.self, forKey: .bannerUrl)
        iconId = try container.decodeIfPresent(String.self, forKey: .iconId)
        iconUrl = try container.decodeIfPresent(URL.self, forKey: .iconUrl)
        ownerId = try container.decode(String.self, forKey: .ownerId)
        privacy = try container.decode(GroupPrivacy.self, forKey: .privacy)
        memberCount = try container.decode(Int.self, forKey: .memberCount)
        onlineMemberCount = try container.decodeIfPresent(Int.self, forKey: .onlineMemberCount)
        
        if let memberVisibilityValue = try? container.decode(GroupMembershipVisibility.self, forKey: .memberVisibility) {
            memberVisibility = memberVisibilityValue
        } else {
            if let myMemberData = try? container.decode(GroupMembership.self, forKey: .myMember) {
                memberVisibility = myMemberData.visibility
            } else {
                memberVisibility = .visible
            }
        }
        
        if let myMemberValue = try? container.decode(GroupMembership.self, forKey: .myMember) {
            print("✅ [GroupModel] Successfully decoded myMember: \(myMemberValue)")
            myMember = myMemberValue
        } else {
            print("⚠️ [GroupModel] Failed to decode myMember, creating default")
            myMember = GroupMembership(
                id: "default_member_id",
                groupId: id,
                userId: "current_user",
                isRepresenting: false,
                isSubscribedToAnnouncements: true,
                visibility: memberVisibility,
                isSubscribedToEvents: true,
                roleIds: [],
                joinedAt: nil,
                rolePermissions: nil,
                roleOrder: nil
            )
        }
        
        mutualGroup = try container.decodeIfPresent(Bool.self, forKey: .mutualGroup) ?? false
        
        if let isRepresentingValue = try? container.decode(Bool.self, forKey: .isRepresenting) {
            isRepresenting = isRepresentingValue
        } else if let myMember = myMember {
            isRepresenting = myMember.isRepresenting
        } else {
            isRepresenting = false
        }
        
        let lastPostCreatedAtString = try container.decodeIfPresent(String.self, forKey: .lastPostCreatedAt)
        lastPostCreatedAt = lastPostCreatedAtString.flatMap { DateFormatter.iso8601Full.date(from: $0) }
        lastPostReadAt = try container.decodeIfPresent(Date.self, forKey: .lastPostReadAt)
        rules = try container.decodeIfPresent(String.self, forKey: .rules)
        isVerified = try container.decodeIfPresent(Bool.self, forKey: .isVerified)
        joinState = try container.decodeIfPresent(GroupJoinState.self, forKey: .joinState)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        languages = try container.decodeIfPresent([String].self, forKey: .languages)
        galleries = try container.decodeIfPresent([GroupGallery].self, forKey: .galleries)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        memberships = try container.decodeIfPresent([GroupMembership].self, forKey: .memberships)
        roles = try container.decodeIfPresent([GroupRole].self, forKey: .roles)
        representable = try container.decodeIfPresent(Bool.self, forKey: .representable)
    }
}
