//
//  APIParameterKey.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIParameterKey: Hashable {
    public let rawValue: String
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}


extension APIParameterKey {
    
    // General
    public static let includeHTML = APIParameterKey("include_html")
    public static let includeCounts = APIParameterKey("include_counts")
    public static let includeRaw = APIParameterKey("include_raw")
    public static let includeDeleted = APIParameterKey("include_deleted")
    public static let includeClient = APIParameterKey("include_client")
}
