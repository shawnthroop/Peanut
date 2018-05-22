//
//  Presence+APIStreamableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Presence: APIStreamableObject {
    
    public enum Stream: Hashable {
        case online
        case user(User.ID)
    }
}


extension Presence.Stream: APIObjectRequestable {
    public typealias Object = Presence
    public typealias Response = APIObjectResponse<Object>
    
    public func endpoint(for api: API) -> APIEndpoint<Response> {
        var result = APIEndpoint<Response>(api: api, path: "")
        
        switch self {
        case .online:
            result.append("presence")
        case .user(let id):
            result.append("users", id.rawValue, "presence")
        }
        
        return result
    }
}

