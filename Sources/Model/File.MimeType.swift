//
//  File.MimeType.swift
//  Peanut
//
//  Created by Shawn Throop on 23.05.18.
//

extension File {
    
    public enum MimeType: Hashable, Codable {
        case text(encoding: String)
        case msWord
        case openDocument
        case rtf
        case xml
        case json
        case javascript
        case mpeg
        case mp4
        case wav
        case flac
        case png
        case jpg
        case gif
    }
}


extension File.MimeType {
    var kind: File.Kind {
        switch self {
        case .text, .msWord, .openDocument, .rtf, .xml, .json, .javascript:
            return .other
        case .mpeg, .mp4, .wav, .flac:
            return .audio
        case .png, .jpg, .gif:
            return .image
        }
    }
}

extension File.MimeType: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case "application/msword":
            self = .msWord
        case "application/vnd.oasis.opendocument.text":
            self = .openDocument
        case "application/rtf":
            self = .rtf
        case "application/xml":
            self = .xml
        case "application/json":
            self = .json
        case "application/javascript":
            self = .javascript
            
        case "audio/mpeg", "audio/mp3":
            self = .mpeg
        case "audio/mp4", "audio/m4a", "audio/x-m4a":
            self = .mp4
        case "audio/wave", "audio/wav", "audio/x-wav", "audio/x-pn-wav":
            self = .wav
        case "audio/flac", "audio/x-flac":
            self = .flac
            
        case "image/png":
            self = .png
        case "image/jpeg", "image/jpg":
            self = .jpg
        case "image/gif":
            self = .gif
            
        default:
            let prefix = rawValue.prefix(5)
            
            guard prefix == "text/" else {
                return nil
            }
            
            self = .text(encoding: String(rawValue.suffix(from: prefix.endIndex)))
        }
    }
    
    public var rawValue: String {
        switch self {
        case .text(let encoding):
            return "text/\(encoding)"
        case .msWord:
            return "application/msword"
        case .openDocument:
            return "application/vnd.oasis.opendocument.text"
        case .rtf:
            return "application/rtf"
        case .xml:
            return "application/xml"
        case .json:
            return "application/json"
        case .javascript:
            return "application/javascript"
        case .mpeg:
            return "audio/mpeg"
        case .mp4:
            return "audio/mp4"
        case .wav:
            return "audio/wave"
        case .flac:
            return "audio/flac"
        case .png:
            return "image/png"
        case .jpg:
            return "image/jpeg"
        case .gif:
            return "image/gif"
        }
    }
}
