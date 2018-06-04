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
    public var link: Link?
    public var shortLink: URL?
    public var isPublic: Bool
    public var isComplete: Bool
    public var isDeleted: Bool
    public var size: Int
    public var audioInfo: AudioInformation? = nil
    public var imageInfo: ImageInformation? = nil
    public var derivatives: [DerivativeKey: Derivative]
    public var user: User.Value?
    public var raw: [Raw]
    public var token: String?
    public var readToken: String?
    public var uploadParameters: UploadParameters?
    public var sha256: String
    public var source: Source
    public var createdAt: Date
    
    public init(id: ID, name: String, type: String, kind: Kind, mimeType: MimeType?, link: Link?, shortLink: URL?, isPublic: Bool, isComplete: Bool, isDeleted: Bool, size: Int, audioInfo: AudioInformation?, imageInfo: ImageInformation?, derivatives: [DerivativeKey: Derivative], user: User.Value?, raw: [Raw], token: String, readToken: String?, uploadParameters: UploadParameters?, sha256: String, source: Source, createdAt: Date) {
        self.id = id
        self.name = name
        self.type = type
        self.kind = kind
        self.mimeType = mimeType
        self.link = link
        self.shortLink = shortLink
        self.isPublic = isPublic
        self.isComplete = isComplete
        self.isDeleted = isDeleted
        self.size = size
        self.imageInfo = imageInfo
        self.audioInfo = audioInfo
        self.derivatives = derivatives
        self.user = user
        self.raw = raw
        self.token = token
        self.readToken = readToken
        self.uploadParameters = uploadParameters
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


extension File: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Identifier<File>.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        kind = try container.decode(Kind.self, forKey: .kind)
        mimeType = try container.decodeIfPresent(MimeType.self, forKey: .mimeType)
        link = try container.decodeIfPresent(URL.self, forKey: .link).map { url in
            return try File.Link(url: url, expiresAt: container.decode(Date.self, forKey: .expiresAt))
        }
        
        shortLink = try container.decodeIfPresent(URL.self, forKey: .shortLink)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
        isComplete = try container.decode(Bool.self, forKey: .isComplete)
        isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        size = try container.decode(Int.self, forKey: .size)

        switch kind {
        case .audio:
            audioInfo = try container.decode(AudioInformation.self, forKey: .audioInfo)
        case .image:
            imageInfo = try container.decode(ImageInformation.self, forKey: .imageInfo)
        default:
            break
        }
        
        derivatives = try container.decode([File.DerivativeKey: File.Derivative].self, forKey: .derivatives)
        user = try container.decodeIfPresent(User.Value.self, forKey: .user)
        raw = try container.decodeIfPresent([Raw].self, forKey: .raw) ?? []
        token = try container.decodeIfPresent(String.self, forKey: .token)
        readToken = try container.decodeIfPresent(String.self, forKey: .readToken)
        uploadParameters = try container.decodeIfPresent(File.UploadParameters.self, forKey: .uploadParameters)
        sha256 = try container.decode(String.self, forKey: .sha256)
        source = try container.decode(Source.self, forKey: .source)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(kind, forKey: .kind)
        try container.encodeIfPresent(mimeType, forKey: .mimeType)
        
        if let link = link {
            try container.encode(link.url, forKey: .link)
            try container.encode(link.expiresAt, forKey: .expiresAt)
        }
        
        try container.encodeIfPresent(shortLink, forKey: .shortLink)
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(isComplete, forKey: .isComplete)
        try container.encode(isDeleted, forKey: .isDeleted)
        try container.encode(size, forKey: .size)
        try container.encodeIfPresent(audioInfo, forKey: .audioInfo)
        try container.encodeIfPresent(imageInfo, forKey: .imageInfo)
        try container.encode(derivatives, forKey: .derivatives)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encode(raw, forKey: .raw)
        try container.encodeIfPresent(token, forKey: .token)
        try container.encodeIfPresent(readToken, forKey: .readToken)
        try container.encodeIfPresent(uploadParameters, forKey: .uploadParameters)
        try container.encode(sha256, forKey: .sha256)
        try container.encode(source, forKey: .source)
        try container.encode(createdAt, forKey: .createdAt)
    }
}


private extension File {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case kind
        case mimeType           = "mime_type"
        case link
        case expiresAt          = "link_expires_at"
        case shortLink          = "link_short"
        case isPublic           = "is_public"
        case isComplete         = "is_complete"
        case isDeleted          = "is_deleted"
        case size
        case audioInfo          = "audio_info"
        case imageInfo          = "image_info"
        case derivatives        = "derived_files"
        case user
        case raw
        case token              = "file_token"
        case readToken          = "file_token_read"
        case uploadParameters   = "upload_parameters"
        case sha256
        case source
        case createdAt          = "created_at"
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


private extension KeyedEncodingContainer where K == File.CodingKeys {
    mutating func encode(_ value: [File.DerivativeKey: File.Derivative], forKey key: K) throws {
        var container = nestedContainer(keyedBy: File.DerivativeKey.self, forKey: key)

        for (k, v) in value {
            try container.encode(v, forKey: k)
        }
    }
}
