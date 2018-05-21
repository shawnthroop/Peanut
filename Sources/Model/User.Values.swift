//
//  User.Values.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public extension User {
    
    public enum Values: Hashable {
        case ids(Set<User.ID>)
        case users(Set<User>)
    }
}


extension User.Values {
    var ids: Set<User.ID> {
        switch self {
        case .ids(let value):
            return value
            
        case .users(let value):
            return value.reduce(into: Set<User.ID>(), { $0.insert($1.id) })
        }
    }
    
    var values: Set<User>? {
        if case let .users(values) = self {
            return values
        }
        
        return nil
    }
}


extension User.Values: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let values = try? container.decode(Set<User>.self) {
            self = .users(values)
        } else {
            self = .ids(try container.decode(Set<User.ID>.self))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .users(let values):
            try container.encode(values)
        case .ids(let values):
            try container.encode(values)
        }
    }
}
