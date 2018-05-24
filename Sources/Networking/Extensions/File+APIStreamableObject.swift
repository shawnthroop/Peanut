//
//  File+APIStreamableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 24.05.18.
//

extension File: APIStreamableObject {
    
    public enum Stream: Hashable {
        case mine
        case file(File.ID)
        case files(Set<File.ID>)
    }
}


extension File.Stream: APIObjectRequestable {
    public typealias Object = File
    public typealias Response = APIObjectResponse<Object>
    
    public func endpoint(for api: API) -> APIEndpoint<Response> {
        var result = APIEndpoint<Response>(api: api, path: "")
        
        switch self {
        case .mine:
            result.append("users", "me", "files")
        case .file(let id):
            result.append("files", id.rawValue)
        case .files(let ids):
            result.append("files")
            result.parameters[.ids] = ids
        }
        
        return result
    }
}


private extension APIParameterKey {
    static let ids = APIParameterKey("ids")
}
