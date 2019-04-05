//
//  Search.swift
//  MastodonKit
//
//  Created by Ornithologist Coder on 4/9/17.
//  Copyright © 2017 MastodonKit. All rights reserved.
//

import Foundation

public struct Search {
    /// Searches for content.
    ///
    /// - Parameters:
    ///   - query: The search query.
    ///   - resolve: Whether to resolve non-local accounts.
    /// - Returns: Request for `Results`.
    public static func search(query: String, resolve: Bool? = nil) -> Request<Results> {
        var res = resolve
        if (UserDefaults.standard.object(forKey: "searchsco") == nil) || (UserDefaults.standard.object(forKey: "searchsco") as! Int == 0) {
            res = false
        } else {
            res = true
        }
        
        let parameters = [
            Parameter(name: "q", value: query),
            Parameter(name: "resolve", value: res.flatMap(trueOrNil))
        ]

        let method = HTTPMethod.get(.parameters(parameters))
        return Request<Results>(path: "/api/v2/search", method: method)
    }
}
