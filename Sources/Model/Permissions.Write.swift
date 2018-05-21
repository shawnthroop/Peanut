//
//  Permissions.Write.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public extension Permissions {
    
    public struct Write: Hashable, Codable {
        public var isImmutable: Bool
        public var anyUser: Bool
        public var you: Bool
        public var users: User.Values
    }
}


private extension Permissions.Write {
    enum CodingKeys: String, CodingKey {
        case isImmutable    = "immutable"
        case anyUser        = "any_user"
        case you
        case users          = "user_ids"
    }
}
