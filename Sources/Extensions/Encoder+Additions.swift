//
//  Encoder+Additions.swift
//  Peanut
//
//  Created by Shawn Throop on 04.06.18.
//

extension KeyedEncodingContainer {
    public mutating func encode<T: Encodable>(_ value: T, forKey key: K, where predicate: (T) -> Bool) throws {
        if predicate(value) {
            try encode(value, forKey: key)
        }
    }
}
