//
//  APIAuthorizationResponse.Token.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension APIAuthorizationResponse {
    
    public struct Token: Hashable, Decodable {
        public var scopes: Set<Client.Scope>
        public var app: Source
        public var clientID: UniqueIdentifier
        public var user: User
    }
}


private extension APIAuthorizationResponse.Token {
    enum CodingKeys: String, CodingKey {
        case scopes
        case app
        case clientID = "client_id"
        case user
    }
}

