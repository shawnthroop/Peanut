//
//  UniquelyIdentifiable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public protocol UniquelyIdentifiable: Identifiable {
    var id: Identifier<Self> { get }
}


extension UniquelyIdentifiable {
    public typealias ID = Identifier<Self>
}
