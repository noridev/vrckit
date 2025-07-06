//
//  VRCPlusModel.swift
//  VRCKit
//
//  Created by NoriDev on 7/7/25.
//

public struct VRCPlus: Equatable, Sendable {
    public let isSupporter: Bool
}

public extension ProfileElementRepresentable {
    var vrcPlus: VRCPlus {
        VRCPlus(isSupporter: tags.systemTags.contains(.systemSupporter))
    }
}
