//
//  File.DerivativeKey.swift
//  Peanut
//
//  Created by Shawn Throop on 24.05.18.
//

extension File {
    
    public enum DerivativeKey: Hashable, Codable {
        case core(String)
        case custom(String)
    }
}


extension File.DerivativeKey {
    static let smallThumbnail: File.DerivativeKey = .core("image_200s")
    static let largeThumbnail: File.DerivativeKey = .core("image_960r")
}


extension File.DerivativeKey: RawRepresentable {
    public init?(rawValue: String) {
        if let core = File.DerivativeKey(coreValue: rawValue) {
            self = core
            
        } else {
            self = .custom(rawValue)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .core(let value):
            return "core_\(value)"
        case .custom(let value):
            return value
        }
    }
}


extension File.DerivativeKey: CodingKey {
    public init?(stringValue: String) {
        self.init(rawValue: stringValue)
    }
    
    public init?(intValue: Int) {
        self.init(rawValue: String(intValue))
    }
    
    public var stringValue: String {
        return rawValue
    }
    
    public var intValue: Int? {
        return Int(rawValue)
    }
}


private extension File.DerivativeKey {
    init?(coreValue: String) {
        let prefix = coreValue.prefix(5)
        guard prefix == "core_" else {
            return nil
        }
        
        self = .core(String(coreValue.suffix(from: prefix.endIndex)))
    }
}
