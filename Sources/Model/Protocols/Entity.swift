//
//  Entity.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol Entity: SurrogatePairAdjustable, Codable {
    var range: Content.Range { get }
    var amendedRange: Content.Range? { get }
}


extension Entity {
    var amendedRange: Content.Range? {
        return nil
    }
}
