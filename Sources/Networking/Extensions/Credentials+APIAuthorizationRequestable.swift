//
//  Credentials+APIAuthorizationRequestable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Authorization: APIAuthorizationRequestable {
    public func endpoint(for api: API) -> APIEndpoint<APIAuthorizationResponse> {
        return APIEndpoint<APIAuthorizationResponse>(api: api, method: .post, path: "oauth/access_token")
    }
    
    public func payload(for api: API) throws -> APIPayload? {
        var params = APIParameters()
        params[.username] = username
        params[.password] = password
        params[.clientID] = client.id
        params[.passwordGrantSecret] = client.passwordGrantSecret
        params[.grantType] = "password"
        params[.scope] = client.scope
        
        return params.rawValues.asPayload()
    }
}


private extension APIParameterKey {
    static let username = APIParameterKey("username")
    static let password = APIParameterKey("password")
    static let clientID = APIParameterKey("client_id")
    static let passwordGrantSecret = APIParameterKey("password_grant_secret")
    static let grantType = APIParameterKey("grant_type")
    static let scope = APIParameterKey("scope")
}


private extension Dictionary where Key == String, Value == String {
    func asPayload() -> APIPayload? {
        return APIPayload(string: map({ "\($0.key)=\($0.value)" }).joined(separator: "&"), encoding: .utf8)
    }
}
