//
//  ChatSettings.Category.swift
//  Peanut
//
//  Created by Shawn Throop on 03.06.18.
//

extension ChatSettings {
    
    public enum Category: String, Hashable, Codable {
        case fun
        case lifestyle
        case profession
        case language
        case community
        case tech
        case event
        case general
    }
}
