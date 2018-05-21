//
//  Permissions.Full.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public extension Permissions {
    
    public struct Full: Hashable, Codable {
        public var isImmutable: Bool
        public var you: Bool
        public var users: User.Values
    }
}


private extension Permissions.Full {
    enum CodingKeys: String, CodingKey {
        case isImmutable    = "immutable"
        case you
        case users          = "user_ids"
    }
}

