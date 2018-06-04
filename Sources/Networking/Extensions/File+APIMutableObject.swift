//
//  File+APIMutableObject.swift
//  Peanut
//
//  Created by Shawn Throop on 24.05.18.
//

extension File: APIMutableObject {
    
    public enum Mutation: Equatable {
        case publish(File.Draft, content: Data, sha256: String?)
        case publishPlaceholder(File.Draft)
    }
}


extension File.Mutation: APIObjectRequestable {
    public typealias Object = File
    public typealias Response = APIObjectResponse<Object>
    
    public func endpoint(for api: API) -> APIEndpoint<Response> {
        return APIEndpoint<Response>(api: api, method: .post, path: "files")
    }
    
    public func payload(for api: API) throws -> APIPayload? {
        switch self {
        case .publish(let draft, let content, let sha256):
            var parameters = draft.toParameters()
            
            if let signature = sha256 {
                parameters[.sha256] = signature
            }
            
            return try APIPayload(formValues: parameters.rawValues, content: (key: APIParameterKey.content.rawValue, data: content))
            
        case .publishPlaceholder(let draft):
            return try APIPayload(formValues: draft.toParameters().rawValues, content: nil)
        }
    }
}


private extension APIParameterKey {
    static let content = APIParameterKey("content")
    static let type = APIParameterKey("type")
    static let kind = APIParameterKey("kind")
    static let name = APIParameterKey("name")
    static let mimeType = APIParameterKey("mime_type")
    static let isPublic = APIParameterKey("is_public")
    static let sha256 = APIParameterKey("sha256")
}


private extension File.Draft {
    func toParameters() -> APIParameters {
        var result = APIParameters()
        result[.type] = type
        result[.kind] = kind.rawValue
        result[.name] = name
        
        if let mimeType = mimeType {
            result[.mimeType] = mimeType.rawValue
        }
        
        if isPublic {
            result[.isPublic] = true
        }
        
        return result
    }
}
