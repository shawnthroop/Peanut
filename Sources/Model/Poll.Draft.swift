//
//  Poll.Draft.swift
//  Peanut
//
//  Created by Shawn Throop on 22.05.18.
//

extension Poll {
    
    public struct Draft: Equatable {
        public var type: String
        public var prompt: String
        public var options: [String]
        public var deadline: Poll.Deadline
        public var isPublic: Bool
        public var isAnonymous: Bool
        
        public init(type: String, prompt: String, options: [String], deadline: Poll.Deadline, isPublic: Bool, isAnonymous: Bool) {
            self.type = type
            self.prompt = prompt
            self.options = options
            self.deadline = deadline
            self.isPublic = isPublic
            self.isAnonymous = isAnonymous
        }
    }
}


extension Poll.Draft: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(prompt, forKey: .prompt)
        
        var optionsContainer = container.nestedUnkeyedContainer(forKey: .options)
        var position = 1
        
        for text in options {
            var optionContainer = optionsContainer.nestedContainer(keyedBy: OptionCodingKeys.self)
            try optionContainer.encode(text, forKey: .text)
            try optionContainer.encode(position, forKey: .position)
            
            position += 1
        }
        
        switch deadline {
        case .date(let date):
            try container.encode(date, forKey: .date)
        case .duration(let duration):
            try container.encode(duration.minutes, forKey: .duration)
        }
        
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(isAnonymous, forKey: .isAnonymous)
    }
}


private extension Poll.Draft {
    enum CodingKeys: String, CodingKey {
        case type
        case prompt
        case options
        case date           = "closed_at"
        case duration
        case isPublic       = "is_public"
        case isAnonymous    = "is_anonymous"
    }
    
    enum OptionCodingKeys: CodingKey {
        case text
        case position
    }
}
