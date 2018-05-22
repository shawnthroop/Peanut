//
//  File.swift
//  Peanut
//
//  Created by Shawn Throop on 23.05.18.
//

public struct File: Equatable {
    public var id: Identifier<File>
    public var name: String
    public var type: String
    public var kind: Kind
    public var mimeType: MimeType?
    public var link: Link
    public var isPublic: Bool
    public var isComplete: Bool
    public var token: String?
    public var readToken: String?
    public var sha256: String
    public var size: Int
    public var source: Source
    public var createdAt: Date
}


extension APIParameterKey {
    public static let includeIncomplete = APIParameterKey("include_incomplete")
    public static let fileTypes = APIParameterKey("file_types")
    public static let excludeFileTypes = APIParameterKey("exclude_file_types")
    public static let includeFileRaw = APIParameterKey("include_file_raw")
}


extension File: UniquelyIdentifiable {
    public typealias IdentifierValue = UniqueIdentifier
}


extension File: APIDefaultParametersProvider {
    public static var defaultParameters: APIParameters = makeDefaultParameters()
}


extension File: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Identifier<File>.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        kind = try container.decode(Kind.self, forKey: .kind)
        mimeType = try container.decodeIfPresent(MimeType.self, forKey: .mimeType)
        link = try Link(from: decoder)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        readToken = try container.decodeIfPresent(String.self, forKey: .readToken)
        sha256 = try container.decode(String.self, forKey: .sha256)
        size = try container.decode(Int.self, forKey: .size)
        source = try container.decode(Source.self, forKey: .source)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
}


private extension File {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case kind
        case mimeType   = "mime_type"
        case link
        case isPublic   = "is_public"
        case isComplete = "is_complete"
        case token      = "file_token"
        case readToken  = "file_token_read"
        case sha256
        case size
        case source
        case createdAt  = "created_at"
    }
    
    static func makeDefaultParameters() -> APIParameters {
        var result = APIParameters()
        result[.includeIncomplete] = true
        result[.includePrivate] = true
        result[.includeRaw] = false
        result[.includeFileRaw] = false
        
        return result
    }
}
