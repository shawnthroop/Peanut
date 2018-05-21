//
//  User+APIStreamableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension User: APIStreamableObject {
    
    public enum Stream: Hashable {
        case user(User.ID)
        case users(Set<User.ID>)
        case following(User.ID)
        case followers(User.ID)
        case muted
        case blocked
    }
}


extension User.Stream: APIDataRequestable {
    public typealias Object = User
    
    public func endpoint(for api: API) -> APIEndpoint<APIDataResponse<Object>> {
        var result = APIEndpoint<APIDataResponse<Object>>(api: api, path: "users")
        
        switch self {
        case .user(let id):
            result.append(id.rawValue)
        case .users(let ids):
            result.parameters[.ids] = ids
        case .following(let id):
            result.append(id.rawValue, "following")
        case .followers(let id):
            result.append(id.rawValue, "followers")
        case .muted:
            result.append("me", "muted")
        case .blocked:
            result.append("me", "blocked")
        }
        
        return result
    }
}


private extension APIParameterKey {
    static let ids = APIParameterKey("ids")
}
