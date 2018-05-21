//
//  User.Value.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public extension User {
    
    public enum Value: Hashable {
        case id(User.ID)
        case user(User)
    }
}


public extension User.Value {
    var id: User.ID {
        switch self {
        case .id(let value):
            return value
            
        case .user(let value):
            return value.id
        }
    }
    
    var value: User? {
        if case let .user(value) = self {
            return value
        }
        
        return nil
    }
}


extension User.Value: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let user = try? container.decode(User.self) {
            self = .user(user)
            
        } else {
            self = .id(try container.decode(User.ID.self))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .id(let id):
            try container.encode(id)
        case .user(let user):
            try container.encode(user)
        }
    }
}
