//
//  User.Badge.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension User {
    
    public struct Badge: Hashable, Codable {
        public let id: Identifier<Badge>
        public let name: String
        
        public init(id: Identifier<Badge>, name: String) {
            self.id = id
            self.name = name
        }
    }
}


extension User.Badge: UniquelyIdentifiable {
    public typealias IdentifierValue = String
}
