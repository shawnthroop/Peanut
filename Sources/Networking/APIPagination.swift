//
//  APIPagination.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

public struct APIPagination: Hashable {
    public static var defaultCount: Int = 20
    
    public var before: UniqueIdentifier?
    public var since: UniqueIdentifier?
    public var count: Int
    
    public init(before: UniqueIdentifier? = nil, since: UniqueIdentifier? = nil, count: Int = APIPagination.defaultCount) {
        self.before = before
        self.since = since
        self.count = count
    }
}


extension APIParameterKey {
    public static let sinceID = APIParameterKey("since_id")
    public static let beforeID = APIParameterKey("before_id")
    public static let count = APIParameterKey("count")
}


extension APIPagination {
    var parameters: APIParameters {
        var result = APIParameters()
        result[.count] = count
        result[.beforeID] = before
        result[.sinceID] = since
        
        return result
    }
}
