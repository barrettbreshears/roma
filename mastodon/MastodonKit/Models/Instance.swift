//
//  Instance.swift
//  MastodonKit
//
//  Created by Ornithologist Coder on 4/9/17.
//  Copyright © 2017 MastodonKit. All rights reserved.
//

import Foundation

public class Instance: Codable {
    /// URI of the current instance.
    public let uri: String
    /// The instance's title.
    public let title: String
    /// A description for the instance.
    public let description: String
    /// An email address which can be used to contact the instance administrator.
    public let email: String
    /// The Mastodon version used by instance (as of version 1.3).
    public let version: String?
    /// Max toot characters for Pleroma (and supported) instances.
    public let max_toot_chars: Int?
    /// Further instance stats
    public let stats: Stats
    /// The instance thumbnail.
    public let thumbnail: String?
}

public class Stats: Codable {
    /// User count
    public let userCount: Int
    /// Status count
    public let statusCount: Int
    /// Domain count
    public let domainCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case userCount = "user_count"
        case statusCount = "status_count"
        case domainCount = "domain_count"
    }
}

public class tagInstances: Codable {
    public let instances: [tagInstancesName]
}

public class tagInstancesName: Codable {
    public let name: String
}
