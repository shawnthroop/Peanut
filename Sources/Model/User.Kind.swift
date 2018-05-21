//
//  User.Kind.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension User {
    
    public enum Kind: String, Hashable, Codable {
        case human
        case feed
        case bot
    }
}


extension User.Kind: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
