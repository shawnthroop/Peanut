//
//  AnyEquatable.swift
//  Peanut
//
//  Created by Shawn Throop on 28.05.18.
//

public struct AnyEquatable {
    public let base: Any
    
    private let valuesAreEqual: (AnyEquatable, AnyEquatable) -> Bool
    
    public init<E>(_ base: E) where E : Equatable {
        self.valuesAreEqual = { AnyEquatable.value($0, ofType: E.self, isEqualTo: $1) }
        self.base = base
    }
}


extension AnyEquatable: Equatable {
    public static func == (lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}


private extension AnyEquatable {
    static func value<T: Equatable>(_ value: AnyEquatable, ofType type: T.Type, isEqualTo other: AnyEquatable) -> Bool {
        guard let lhv = value.base as? T else {
            fatalError("Value of base will always be \(T.self)")
        }
        
        guard let rhv = other.base as? T else {
            return false
        }
        
        return lhv == rhv
    }
    
    
    private func isEqual(to other: AnyEquatable) -> Bool {
        return valuesAreEqual(self, other)
    }
}


extension AnyEquatable: CustomStringConvertible {
    public var description: String {
        if let nested = base as? AnyEquatable {
            return String(describing: nested.base)
        }
        
        return String(describing: base)
    }
}
