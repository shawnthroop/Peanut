//
//  User+APIActionableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension User: APIActionableObject {
    
    public enum Action: Hashable {
        case follow(User.ID)
        case unfollow(User.ID)
        case mute(User.ID)
        case unmute(User.ID)
        case block(User.ID)
        case unblock(User.ID)
    }
}


extension User.Action: APIDataRequestable {
    public typealias Object = User
    
    public func endpoint(for api: API) -> APIEndpoint<APIDataResponse<Object>> {
        let values: (id: User.ID, method: APIMethod, suffix: String)
        
        switch self {
        case .follow(let id):
            values = (id, .put, "follow")
        case .unfollow(let id):
            values = (id, .delete, "follow")
        case .mute(let id):
            values = (id, .put, "mute")
        case .unmute(let id):
            values = (id, .delete, "mute")
        case .block(let id):
            values = (id, .put, "block")
        case .unblock(let id):
            values = (id, .delete, "block")
        }
        
        var result = APIEndpoint<APIDataResponse<Object>>(api: api, method: values.method, path: "users")
        result.append(values.id.rawValue, values.suffix)
        
        return result
    }
}
