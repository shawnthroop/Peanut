//
//  Poll+APIMutableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Poll: APIMutableObject {
    
    public enum Mutation: Equatable {
        case publish(Poll.Draft)
        case respondTo(Poll.ID, position: Int)
        case delete(Poll.ID)
    }
}


extension Poll.Mutation: APIObjectRequestable {
    public typealias Object = Poll
    public typealias Response = APIObjectResponse<Object>
    
    public func endpoint(for api: API) -> APIEndpoint<Response> {
        var result = APIEndpoint<Response>(api: api, path: "polls")
        
        switch self {
        case .publish:
            result.method = .post
            
        case .respondTo(let id, let position):
            result.method = .put
            result.append(id.rawValue, "response", String(position))
            
        case .delete(let id):
            result.method = .delete
            result.append(id.rawValue)
        }
        
        return result
    }
    
    public func payload(for api: API) throws -> APIPayload? {
        switch self {
        case .publish(let draft):
            return try APIPayload(value: draft, api: api)
        default:
            return nil
        }
    }
}
