//
//  Permissions.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Permissions: Hashable, Codable {
    public var full: Full
    public var write: Write
    public var read: Read
}
