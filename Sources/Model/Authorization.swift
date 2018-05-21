//
//  Authorization.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct Authorization: Hashable {
    public var username: String
    public var password: String
    public var client: Client
    
    public init(username: String, password: String, client: Client = .shared) {
        self.username = username
        self.password = password
        self.client = client
    }
}
