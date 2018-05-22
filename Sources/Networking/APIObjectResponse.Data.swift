//
//  APIObjectResponse.Data.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

extension APIObjectResponse {
    
    public enum Data {
        case single(T)
        case multiple([T])
    }
}



extension APIObjectResponse.Data: Sequence {
    public typealias Element = T
    
    public func makeIterator() -> AnyIterator<Element> {
        switch self {
        case .single(let item):
            return wrap(iterator: IteratorOverOne(_elements: item))
        case .multiple(let items):
            return wrap(iterator: items.makeIterator())
        }
    }
}


extension APIObjectResponse.Data: Collection {
    public subscript(position: Int) -> Element {
        switch self {
        case .single(let item):
            precondition(position == 0, "Index out of bounds")
            return item
            
        case .multiple(let items):
            return items[position]
        }
    }
    
    public var startIndex: Int {
        return items?.startIndex ?? 0
    }
    
    public var endIndex: Int {
        return items?.endIndex ?? 1
    }
    
    public func index(after i: Int) -> Int {
        guard let next = items?.index(after: i) else {
            precondition(i == 0, "Index out of range")
            return 1
        }
        
        return next
    }
}


extension APIObjectResponse.Data: BidirectionalCollection {
    public func index(before i: Int) -> Int {
        guard let prev = items?.index(before: i) else {
            precondition(i == 1, "Index out of range")
            return 1
        }
        
        return prev
    }
}


extension APIObjectResponse.Data: Equatable where Element: Equatable {
    public static func ==<T>(lhs: APIObjectResponse<T>.Data, rhs: APIObjectResponse<T>.Data) -> Bool where T: Equatable {
        switch (lhs, rhs) {
        case (.single(let item), .single(let otherItem)):
            return item == otherItem
        case (.multiple(let items), .multiple(let otherItems)):
            return items == otherItems
        default:
            return false
        }
    }
}


extension APIObjectResponse.Data: Decodable where Element: Decodable {
    public init(from decoder: Decoder) throws {
        if var unkeyedContainer = try? decoder.unkeyedContainer() {
            var items = [Element]()
            while unkeyedContainer.isAtEnd == false {
                let item = try unkeyedContainer.decode(Element.self)
                items.append(item)
            }
            
            self = .multiple(items)
            
        } else {
            self = .single(try decoder.singleValueContainer().decode(Element.self))
        }
    }
}


extension APIObjectResponse.Data: Encodable where Element: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .single(let item):
            var container = encoder.singleValueContainer()
            try container.encode(item)
            
        case .multiple(let items):
            var container = encoder.unkeyedContainer()
            for item in items {
                try container.encode(item)
            }
        }
    }
}


private extension APIObjectResponse.Data {
    var items: [Element]? {
        if case let .multiple(items) = self {
            return items
        }
        
        return nil
    }
    
    func wrap<T: IteratorProtocol>(iterator: T) -> AnyIterator<Element> where T.Element == Element {
        var iterator = iterator
        
        return AnyIterator {
            return iterator.next()
        }
    }
}
