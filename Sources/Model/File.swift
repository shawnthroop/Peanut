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
    public var shortLink: URL?
    public var isPublic: Bool
    public var isComplete: Bool
    public var size: Int
    public var audioInfo: AudioInformation? = nil
    public var imageInfo: ImageInformation? = nil
    public var derivatives: [DerivativeKey: Derivative]
    public var user: User.Value?
    public var token: String?
    public var readToken: String?
    public var sha256: String
    public var source: Source
    public var createdAt: Date
    
    public init(id: ID, name: String, type: String, kind: Kind, mimeType: MimeType?, link: Link, shortLink: URL?, isPublic: Bool, isComplete: Bool, size: Int, audioInfo: AudioInformation?, imageInfo: ImageInformation?, derivatives: [DerivativeKey: Derivative], user: User.Value?, token: String, readToken: String?, sha256: String, source: Source, createdAt: Date) {
        self.id = id
        self.name = name
        self.type = type
        self.kind = kind
        self.mimeType = mimeType
        self.link = link
        self.shortLink = shortLink
        self.isPublic = isPublic
        self.isComplete = isComplete
        self.size = size
        self.imageInfo = imageInfo
        self.audioInfo = audioInfo
        self.derivatives = derivatives
        self.user = user
        self.token = token
        self.readToken = readToken
        self.sha256 = sha256
        self.source = source
        self.createdAt = createdAt
    }
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
        shortLink = try container.decodeIfPresent(URL.self, forKey: .shortLink)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        size = try container.decode(Int.self, forKey: .size)

        switch kind {
        case .audio:
            audioInfo = try container.decode(AudioInformation.self, forKey: .audioInfo)
        case .image:
            imageInfo = try container.decode(ImageInformation.self, forKey: .imageInfo)
        default:
            break
        }
        
        derivatives = try container.decode([File.DerivativeKey: File.Derivative].self, forKey: .derivative)
        user = try container.decodeIfPresent(User.Value.self, forKey: .user)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        readToken = try container.decodeIfPresent(String.self, forKey: .readToken)
        sha256 = try container.decode(String.self, forKey: .sha256)
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
        case shortLink  = "link_short"
        case isPublic   = "is_public"
        case isComplete = "is_complete"
        case size
        case audioInfo  = "audio_info"
        case imageInfo  = "image_info"
        case derivative = "derived_files"
        case user
        case token      = "file_token"
        case readToken  = "file_token_read"
        case sha256
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


private extension KeyedDecodingContainer where K == File.CodingKeys {
    func decode(_ type: [File.DerivativeKey: File.Derivative].Type, forKey key: K) throws -> [File.DerivativeKey: File.Derivative] {
        let container = try nestedContainer(keyedBy: File.DerivativeKey.self, forKey: key)
        var result: [File.DerivativeKey: File.Derivative] = [:]
        
        for k in container.allKeys {
            result[k] = try container.decode(File.Derivative.self, forKey: k)
        }
        
        return result
    }
}
