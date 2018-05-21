//
//  Post+APIStreamableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Post: APIStreamableObject {
    
    public enum Stream: Hashable {
        case me
        case unified
        case mentions(Post.ID)
        case createdBy(User.ID)
        case global
        case hastags(Hashtag)
        case repliesTo(Post.ID)
    }
}


extension Post.Stream: APIDataRequestable {
    public typealias Object = Post
    
    public func endpoint(for api: API) -> APIEndpoint<APIDataResponse<Object>> {
        var result = APIEndpoint<APIDataResponse<Object>>(api: api, path: "")
        
        switch self {
        case .me:
            result.append("posts", "streams", "me")
        case .unified:
            result.append("posts", "streams", "unified")
        case .mentions(let id):
            result.append("users", id.rawValue, "mentions")
        case .createdBy(let id):
            result.append("users", id.rawValue, "posts")
        case .global:
            result .append("posts", "streams", "global")
        case .hastags(let tag):
            result.append("posts", "tags", tag.text)
        case .repliesTo(let id):
            result.append("posts", id.rawValue, "thread")
        }
        
        return result
    }
}
