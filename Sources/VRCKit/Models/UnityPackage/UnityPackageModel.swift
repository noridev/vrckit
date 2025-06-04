//
//  UnityPackageModel.swift
//  VRCKit
//
//  Created by makinosp on 2024/09/29.
//

import Foundation
import MemberwiseInit

@MemberwiseInit(.public)
public struct UnityPackage: Sendable, Identifiable, Hashable {
    public let id: String
    @InitWrapper(type: SafeDecoding<URL>)
    public let assetUrl: SafeDecoding<URL>
    public let assetVersion: Int
    public let createdAt: OptionalISO8601Date
    public let platform: Platform
    public let unitySortNumber: Int
    public let unityVersion: String

    public enum Platform: String, Codable, Sendable {
        case android, ios, standalonewindows
    }

    public var safeAssetUrl: URL? {
        return assetUrl.wrappedValue
    }
}

extension UnityPackage: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, assetUrl, assetVersion, createdAt, platform, unitySortNumber, unityVersion
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        assetUrl = try container.decode(SafeDecoding<URL>.self, forKey: .assetUrl)
        assetVersion = try container.decode(Int.self, forKey: .assetVersion)
        createdAt = try container.decodeIfPresent(OptionalISO8601Date.self, forKey: .createdAt) ?? OptionalISO8601Date()
        platform = try container.decode(UnityPackage.Platform.self, forKey: .platform)
        unitySortNumber = try container.decode(Int.self, forKey: .unitySortNumber)
        unityVersion = try container.decode(String.self, forKey: .unityVersion)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(assetUrl, forKey: .assetUrl)
        try container.encode(assetVersion, forKey: .assetVersion)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(platform, forKey: .platform)
        try container.encode(unitySortNumber, forKey: .unitySortNumber)
        try container.encode(unityVersion, forKey: .unityVersion)
    }
}
