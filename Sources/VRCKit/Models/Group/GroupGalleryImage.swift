//
//  GroupGalleryImage.swift
//  VRCKit
//
//  Created by NoriDev on 7/18/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct GroupGalleryImage: Codable, Sendable, Identifiable, Hashable {
    public let id: String
    public let groupId: String
    public let galleryId: String
    public let fileId: String
    public let imageUrl: URL
    public let createdAt: Date
    public let submittedByUserId: String
    public let approved: Bool?
    public let approvedByUserId: String?
    public let approvedAt: Date?
}
