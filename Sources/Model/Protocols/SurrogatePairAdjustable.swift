//
//  SurrogatePairAdjustable.swift
//  Peanut
//
//  Created by Shawn Throop on 21.05.18.
//

/// A type which can be adjusted to accomidate SurrogatePairs.
public protocol SurrogatePairAdjustable {
    
    /// Creates a new instance adjusted for the given surrogate pairs.
    ///
    /// - Parameter pairs: The pairs to base adjustments on.
    func adjusted(for pairs: Set<String.SurrogatePair>) -> Self
}


extension SurrogatePairAdjustable {
    public mutating func adjust(for pairs: Set<String.SurrogatePair>) {
        self = adjusted(for: pairs)
    }
}
