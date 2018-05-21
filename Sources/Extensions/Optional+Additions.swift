//
//  Optional+Additions.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Optional: Hashable where Wrapped: Hashable {
    public var hashValue: Int {
        guard case let .some(value) = self else {
            return 0.hashValue
        }
        
        return 1.hashValue ^ value.hashValue
    }
}
