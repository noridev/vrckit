//
//  BadgeUpdateModel.swift
//  VRCKit
//
//  Created by NoriDev on 7/13/25.
//

import Foundation

public struct BadgeUpdateRequest: Codable, Sendable {
    public let showcased: Bool?
    public let hidden: Bool?
    
    public init(showcased: Bool? = nil, hidden: Bool? = nil) {
        self.showcased = showcased
        self.hidden = hidden
    }
}

public struct BadgeUpdateResponse: Codable, Sendable {
    public let success: Bool
    public let message: String?
    
    public init(success: Bool, message: String? = nil) {
        self.success = success
        self.message = message
    }
}
