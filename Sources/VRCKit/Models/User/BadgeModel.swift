//
//  BadgeModel.swift
//  VRCKit
//
//  Created by NoriDev on 7/13/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct Badge: Codable, Sendable, Hashable {
    public let assignedAt: Date?
    public let badgeDescription: String
    public let badgeId: String
    public let badgeImageUrl: URL?
    public let badgeName: String
    public let hidden: Bool?
    public let showcased: Bool
    public let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case assignedAt
        case badgeDescription
        case badgeId
        case badgeImageUrl
        case badgeName
        case hidden
        case showcased
        case updatedAt
    }
}

extension Badge: Identifiable {
    public var id: String { badgeId }
}

extension Badge {
    public init(fromPartialUpdate partial: BadgePartialUpdate) {
        self.badgeId = partial.badgeId
        self.badgeName = partial.badgeName ?? "Unknown Badge"
        self.badgeDescription = partial.badgeDescription ?? "No description available"
        self.badgeImageUrl = partial.badgeImageUrl
        self.showcased = partial.showcased ?? false
        self.hidden = partial.hidden
        self.assignedAt = partial.assignedAt
        self.updatedAt = partial.updatedAt
    }
}

public struct BadgePartialUpdate: Codable, Sendable {
    public let assignedAt: Date?
    public let badgeId: String
    public let badgeName: String?
    public let badgeDescription: String?
    public let badgeImageUrl: URL?
    public let hidden: Bool?
    public let showcased: Bool?
    public let updatedAt: Date?
    
    public init(
        assignedAt: Date? = nil,
        badgeId: String,
        badgeName: String? = nil,
        badgeDescription: String? = nil,
        badgeImageUrl: URL? = nil,
        hidden: Bool? = nil,
        showcased: Bool? = nil,
        updatedAt: Date? = nil
    ) {
        self.assignedAt = assignedAt
        self.badgeId = badgeId
        self.badgeName = badgeName
        self.badgeDescription = badgeDescription
        self.badgeImageUrl = badgeImageUrl
        self.hidden = hidden
        self.showcased = showcased
        self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case assignedAt
        case badgeId
        case badgeName
        case badgeDescription
        case badgeImageUrl
        case hidden
        case showcased
        case updatedAt
    }
} 
