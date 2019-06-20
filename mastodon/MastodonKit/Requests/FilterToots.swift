//
//  FilterToots.swift
//  mastodon
//
//  Created by Shihab Mehboob on 03/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation

public struct FilterToots {
    /// Fetches a user's filters.
    ///
    /// - Returns: Request for `[Filters]`.
    public static func all(range: RequestRange = .default) -> Request<[Filters]> {
        return Request<[Filters]>(path: "/api/v1/filters", method: .get(.empty))
    }
    
    /// Fetches a filter by id.
    ///
    /// - Parameters:
    ///   - id: The filter id.
    /// - Returns: Request for `Filters`.
    public static func singleFilter(id: String) -> Request<Filters> {
        return Request<Filters>(path: "/api/v1/filters/\(id)", method: .get(.empty))
    }
    
    /// Posts a new filter.
    ///
    /// - Parameters:
    ///   - phrase: The phrase to filter.
    ///   - context: The context to filter on.
    /// - Returns: Request for `Status`.
    public static func create(phrase: String, context: [Context2]) -> Request<Filters> {
        let res: Bool? = true
        let parameters = [
            Parameter(name: "phrase", value: phrase),
            Parameter(name: "irreversible", value: nil),
            Parameter(name: "whole_word", value: res.flatMap(trueOrNil)),
            Parameter(name: "expires_in", value: nil),
        ] + context.map(toArrayOfParameters(withName: "context"))
        
        let method = HTTPMethod.post(.parameters(parameters))
        return Request<Filters>(path: "/api/v1/filters", method: method)
    }
    
    /// Delete a filter.
    ///
    /// - Parameter id: The filter id.
    public static func delete(id: String) -> Request<Empty> {
        return Request<Empty>(path: "/api/v1/filters/\(id)", method: .delete(.empty))
    }
}
