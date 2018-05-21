//
//  APIAuthorizationResponse.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIAuthorizationResponse: Hashable, Decodable {
    public var id: User.ID
    public var username: String
    public var accessToken: String
    public var token: APIAuthorizationResponse.Token
    public var storage: APIAuthorizationResponse.Storage
}


extension APIAuthorizationResponse: APIDefaultParametersProvider {
    public static let defaultParameters: APIParameters = [:]
}


private extension APIAuthorizationResponse {
    enum CodingKeys: String, CodingKey {
        case id             = "user_id"
        case username
        case accessToken    = "access_token"
        case token
        case storage
    }
}
