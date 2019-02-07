//
//  Filter.swift
//  mastodon
//
//  Created by Shihab Mehboob on 03/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation

public class Filters: Codable {
    /// The ID of the filter.
    public var id: String
    /// The phrase to filter.
    public let phrase: String
    /// Array of strings that means filtering context. Each string is one of home, notifications, public, thread. At least one context must be specified.
    public let context: [Context2]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case phrase
        case context
    }
}

extension Filters: Equatable {}

public func ==(lhs: Filters, rhs: Filters) -> Bool {
    let areEqual = lhs.id == rhs.id &&
        lhs.id == rhs.id
    
    return areEqual
}

