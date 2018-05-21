//
//  Source.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Source: Hashable, Codable {
    
    // The unique identifier of the source
    public var id: Identifier<Source>
    
    /// The name provided by the developer of the source
    public var name: String
    
    /// The permalink provided by the developer of the source
    public var link: URL
    
    public init(id: Identifier<Source>, name: String, link: URL) {
        self.id = id
        self.name = name
        self.link = link
    }
}


extension Source: UniquelyIdentifiable {
    public typealias IdentifierValue = String
}
