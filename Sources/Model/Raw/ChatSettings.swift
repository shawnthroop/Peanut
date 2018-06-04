//
//  ChatSettings.swift
//  Peanut
//
//  Created by Shawn Throop on 03.06.18.
//

public struct ChatSettings: Equatable {
    public var name: String
    public var description: String?
    public var categories: Set<Category>?
    public var unvalidatedContent: RawUnvalidatedContent
    
    public init(name: String, description: String?, categories: Set<Category>?, unvalidatedContent: RawUnvalidatedContent = .empty) {
        self.name = name
        self.description = description
        self.categories = categories
        self.unvalidatedContent = unvalidatedContent
    }
}


extension Identifier where T == Raw {
    public static let chatSettings: Identifier = "io.pnut.core.chat-settings"
}


extension ChatSettings: RawContentValueType {
    public static var validDecodableKeys: Keys = makeValidDecodableKeys()
}


extension ChatSettings: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Identifier<RawContent>.self)
        name = try container.decode(String.self, forKey: .chatName)
        description = try container.decodeIfPresent(String.self, forKey: .chatDescription)
        categories = try container.decodeIfPresent(Set<Category>.self, forKey: .chatCategories)
        unvalidatedContent = try container.decodeUnvalidatedContent(for: ChatSettings.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Identifier<RawContent>.self)
        try container.encode(name, forKey: .chatName)
        try container.encodeIfPresent(description, forKey: .chatDescription)
        try container.encodeIfPresent(categories, forKey: .chatCategories)
        try container.encodeUnvalidatedContent(unvalidatedContent)
    }
}


private extension Identifier where T == RawContent {
    static let chatName: Identifier = "name"
    static let chatDescription: Identifier = "description"
    static let chatCategories: Identifier = "categories"
}


private extension ChatSettings {
    static func makeValidDecodableKeys() -> Keys {
        var result = Keys()
        result.insert(.chatName)
        result.insert(.chatDescription)
        result.insert(.chatCategories)
        
        return result
    }
}
