//
//  SafeDecodingArray.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/28.
//

import MemberwiseInit

@propertyWrapper @MemberwiseInit(.public)
public struct SafeDecodingArray<T> {
    @Init(default: []) public var wrappedValue: [T]
}

extension SafeDecodingArray: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            var container = try decoder.unkeyedContainer()
            var elements: [T] = .init()
            while !container.isAtEnd {
                if let element = try? container.decode(T.self) {
                    elements.append(element)
                } else {
                    // Skip the decorder cursor
                    _ = try? container.decode(Empty.self)
                }
            }
            wrappedValue = elements
        } catch {
            wrappedValue = []
        }
    }
}

private struct Empty: Decodable {}

extension SafeDecodingArray: Hashable where T: Hashable {
    public static func == (lhs: SafeDecodingArray<T>, rhs: SafeDecodingArray<T>) -> Bool {
        lhs.wrappedValue.hashValue == rhs.wrappedValue.hashValue
    }
}

extension SafeDecodingArray: Encodable where T: Encodable {}
extension SafeDecodingArray: Equatable where T: Equatable {}
extension SafeDecodingArray: Sendable where T: Sendable {}
