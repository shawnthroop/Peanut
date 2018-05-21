//
//  APIMarker.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIMarker: Hashable, Codable {
    
    /// The name of the marker.
    public var name: Name
    
    /// The current position of the marker.
    public var id: Identifier<APIMarker>
    
    /// The last item in the stream that has ever been consumed by the marker.
    /// To move this value in reverse, you must include the query parameter reset_read_id=1
    public var lastRead: UniqueIdentifier
    
    public var percentage: Float?
    public var updatedAt: Date
    public var version: String
    
    public init(name: Name, id: Identifier<APIMarker>, lastRead: UniqueIdentifier, percentage: Float? = nil, updatedAt: Date, version: String) {
        self.name = name
        self.id = id
        self.lastRead = lastRead
        self.percentage = percentage
        self.updatedAt = updatedAt
        self.version = version
    }
}


extension APIMarker: UniquelyIdentifiable {
    public typealias IdentifierValue = UniqueIdentifier
}


extension APIParameterKey {
    public static let updateMarker = APIParameterKey("update_marker")
    public static let resetReadID = APIParameterKey("reset_read_id")
}


private extension APIMarker {
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case lastRead   = "last_read_id"
        case percentage
        case updatedAt  = "updated_at"
        case version
    }
}
