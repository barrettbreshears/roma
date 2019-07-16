//
//  Poll.swift
//  mastodon
//
//  Created by Shihab Mehboob on 04/03/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation

public class Poll: Codable {
    /// The poll ID.
    public let id: String
    /// Poll expired?
    public let expired: Bool
    /// The time the poll expires.
    public let expiresAt: Date?
    /// Whether the poll allows multiple choices.
    public let multiple: Bool
    /// The poll vote count.
    public let votesCount: Int
    /// Voted?
    public let voted: Bool?
    /// Options.
    public let options: [PollOptions]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case expired
        case expiresAt = "expires_at"
        case multiple
        case votesCount = "votes_count"
        case voted
        case options
    }
    
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            id = String(try values.decode(Int.self, forKey: .id))
        } catch {
            id = try values.decode(String.self, forKey: .id)
        }
        expired = try values.decode(Bool.self, forKey: .expired)
        expiresAt = try? values.decode(Date.self, forKey: .expiresAt)
        multiple = try values.decode(Bool.self, forKey: .multiple)
        votesCount = try values.decode(Int.self, forKey: .votesCount)
        voted = try values.decode(Bool.self, forKey: .voted)
        options = try values.decode([PollOptions].self, forKey: .options)
        
    }
    
}

public class PollOptions: Codable {
    /// The poll title.
    public let title: String
    /// Poll votes count.
    public let votesCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case votesCount = "votes_count"
    }
}

public class PollPost: Codable {
    public let options: [String]
    public let expiresIn: Int
    public let multiple: Bool?
    public let hideTotals: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case options
        case expiresIn = "expires_in"
        case multiple
        case hideTotals = "hide_totals"
    }
}

extension Poll: Equatable {}

public func ==(lhs: Poll, rhs: Poll) -> Bool {
    let areEqual = lhs.id == rhs.id &&
        lhs.id == rhs.id
    
    return areEqual
}
