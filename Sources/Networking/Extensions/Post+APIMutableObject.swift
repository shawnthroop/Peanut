//
//  Post+APIMutableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension Post: APIMutableObject {
    
    public enum Mutation: Equatable {
        case publish(Draft, updatePersonalStreamMarker: Bool)
        case delete(Post.ID)
    }
}


extension Post.Mutation: APIObjectRequestable {
    public typealias Object = Post
    public typealias Response = APIObjectResponse<Object>
    
    public func endpoint(for api: API) -> APIEndpoint<Response> {
        var result = APIEndpoint<Response>(api: api, path: "posts")
        
        switch self {
        case .publish(_, let updatePersonalStreamMarker):
            result.method = .post
            result.parameters = [.updateMarker: updatePersonalStreamMarker]
            
        case .delete(let id):
            result.method = .delete
            result.append(id.rawValue)
        }
        
        return result
    }
    
    public func payload(for api: API) throws -> APIPayload? {
        switch self {
        case .publish(let draft, _):
            return try APIPayload(value: draft, api: api)
        default:
            return nil
        }
    }
}
