//
//  Presence+APIMutableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Presence: APIMutableObject {
    
    public enum Mutation: Hashable {
        case update(Presence.Status)
    }
}


extension Presence.Mutation: APIObjectRequestable {
    public typealias Object = Presence
    public typealias Response = APIObjectResponse<Object>
    
    public func endpoint(for api: API) -> APIEndpoint<Response> {
        var result = APIEndpoint<Response>(api: api, path: "")
        
        switch self {
        case .update:
            result.append("users", "me", "presence")
            result.method = .put
        }
        
        return result
    }
    
    public func payload(for api: API) throws -> APIPayload? {
        switch self {
        case .update(let status):
            let parameters: APIParameters = [.presence: status]
            return APIPayload(string: parameters.rawValues.asPostBody(), encoding: .utf8)
        }
    }
}


private extension APIParameterKey {
    static let presence = APIParameterKey("presence")
}
