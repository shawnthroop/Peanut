//
//  Post+APIActionableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Post: APIActionableObject {
    
    public enum Action: Hashable {
        case bookmark(Post.ID)
        case unbookmark(Post.ID)
        case repost(Post.ID)
        case unrepost(Post.ID)
    }
}


extension Post.Action: APIDataRequestable {
    public typealias Object = Post
    
    public func endpoint(for api: API) -> APIEndpoint<APIDataResponse<Object>> {
        var values: (id: Post.ID, method: APIMethod, suffix: String)
        
        switch self {
        case .bookmark(let id):
            values = (id, .put, "bookmark")
        case .unbookmark(let id):
            values = (id, .delete, "bookmark")
        case .repost(let id):
            values = (id, .put, "repost")
        case .unrepost(let id):
            values = (id, .delete, "repost")
        }
        
        var result = APIEndpoint<APIDataResponse<Object>>(api: api, method: values.method, path: "posts")
        result.append(values.id.rawValue, values.suffix)
        
        return result
        
    }
}
