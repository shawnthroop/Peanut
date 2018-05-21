//
//  Identifiable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol Identifiable {
    associatedtype IdentifierValue: Hashable
}
