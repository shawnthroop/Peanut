//
//  Poll+APIStreamableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Poll: APIStreamableObject {
    
    public enum Stream: Hashable {
        case polls
        case poll(Identifier<Poll>)
    }
}


extension Poll.Stream: APIObjectRequestable {
    public typealias Object = Poll
    public typealias Response = APIObjectResponse<Object>
    
    public func endpoint(for api: API) -> APIEndpoint<Response> {
        var result = APIEndpoint<Response>(api: api, path: "")
        
        switch self {
        case .polls:
            result.append("users", "me", "polls")
        case .poll(let id):
            result.append("polls", id.rawValue)
        }
        
        return result
    }
}
