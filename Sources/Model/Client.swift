//
//  Client.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Client: Hashable {
    public static var shared = Client(id: "", passwordGrantSecret: "", scope: [])
    
    public var id: Identifier<Client>
    public var passwordGrantSecret: String
    public var scope: Set<Scope>
    
    public init(id: ID, passwordGrantSecret: String, scope: Set<Scope>) {
        self.id = id
        self.passwordGrantSecret = passwordGrantSecret
        self.scope = scope
    }
}


extension Client: UniquelyIdentifiable {
    public typealias IdentifierValue = String
}
