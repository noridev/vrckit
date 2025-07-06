//
//  AgeVerificationModel.swift
//  VRCKit
//
//  Created by makinosp on 2025/02/26.
//

import SwiftUI

public enum AgeVerificationStatus: String, Codable, Sendable {
    case hidden
    case verified
    case over18 = "18+"
}

public struct AgeVerification: Equatable, Sendable {
    public let ageVerified: Bool
    public let ageVerificationStatus: AgeVerificationStatus

    public var ageVerificationStatusLabel: String? {
        guard ageVerified else { return nil }
        switch ageVerificationStatus {
        case .over18:
            return "18+"
        case .hidden:
            return "Hidden"
        default:
            return nil
        }
    }
}

public extension ProfileDetailRepresentable {
    var ageVerification: AgeVerification {
        AgeVerification(ageVerified: self.ageVerified, ageVerificationStatus: self.ageVerificationStatus)
    }
}
