//  GroupPostModel.swift
//  VRCKit
//
//  Created by NoriDev on 7/18/25.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct GroupPost: Codable, Sendable, Identifiable {
    public let id: String
    public let groupId: String
    public let authorId: String
    public let editorId: String?
    public let visibility: String?
    public let roleId: [String]?
    public let title: String
    public let text: String
    public let imageId: String?
    public let imageUrl: String?
    public let createdAt: Date?
    public let updatedAt: Date?
    
    public var content: String { text }
    public var images: [URL]? {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return nil }
        return [url]
    }
}
