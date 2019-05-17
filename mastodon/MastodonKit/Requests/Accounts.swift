//
//  Accounts.swift
//  MastodonKit
//
//  Created by Ornithologist Coder on 4/9/17.
//  Copyright © 2017 MastodonKit. All rights reserved.
//

import Foundation
import UIKit

public struct Accounts {
    /// Fetches an account.
    ///
    /// - Parameter id: The account id.
    /// - Returns: Request for `Account`.
    public static func account(id: String) -> Request<Account> {
        return Request<Account>(path: "/api/v1/accounts/\(id)")
    }

    /// Gets the current user.
    ///
    /// - Returns: Request for `Account`.
    public static func currentUser() -> Request<Account> {
        return Request<Account>(path: "/api/v1/accounts/verify_credentials")
    }

    /// Updates the current user.
    ///
    /// - Parameters:
    ///   - displayName: The name to display in the user's profile.
    ///   - note: A new biography for the user.
    ///   - avatar: The media attachment to display as the user's avatar.
    ///   - header: The media attachment to display as the user's header image.
    /// - Returns: Request for `Account`.
    public static func updateCurrentUser(displayName: String? = nil,
                                         note: String? = nil,
                                         avatar: MediaAttachment? = nil,
                                         header: MediaAttachment? = nil,
                                         locked: Bool? = nil,
                                         fieldName1: String? = nil,
                                         fieldValue1: String? = nil,
                                         fieldName2: String? = nil,
                                         fieldValue2: String? = nil,
                                         fieldName3: String? = nil,
                                         fieldValue3: String? = nil,
                                         fieldName4: String? = nil,
                                         fieldValue4: String? = nil) -> Request<Account> {
        var lockText = "false"
        if locked == true {
            lockText = "true"
        } else {
            lockText = "false"
        }
        
        let parameters = [
            Parameter(name: "display_name", value: displayName),
            Parameter(name: "note", value: note),
            Parameter(name: "locked", value: lockText),
            Parameter(name: "fields_attributes[0][name]", value: fieldName1),
            Parameter(name: "fields_attributes[0][value]", value: fieldValue1),
            Parameter(name: "fields_attributes[1][name]", value: fieldName2),
            Parameter(name: "fields_attributes[1][value]", value: fieldValue2),
            Parameter(name: "fields_attributes[2][name]", value: fieldName3),
            Parameter(name: "fields_attributes[2][value]", value: fieldValue3),
            Parameter(name: "fields_attributes[3][name]", value: fieldName4),
            Parameter(name: "fields_attributes[3][value]", value: fieldValue4)
        ]

        if avatar != nil {
            let method = HTTPMethod.patch(.media(avatar!))
            return Request<Account>(path: "/api/v1/accounts/update_credentials", method: method)
        } else if header != nil {
            let method = HTTPMethod.patch(.media(header!))
            return Request<Account>(path: "/api/v1/accounts/update_credentials", method: method)
        } else {
            let method = HTTPMethod.patch(.parameters(parameters))
            return Request<Account>(path: "/api/v1/accounts/update_credentials", method: method)
        }
    }

    /// Gets an account's followers.
    ///
    /// - Parameters:
    ///   - id: The account id.
    ///   - range: The bounds used when requesting data from Mastodon.
    /// - Returns: Request for `[Account]`.
    public static func followers(id: String, range: RequestRange = .default) -> Request<[Account]> {
        let parameters = range.parameters(limit: between(1, and: 80, default: 40))
        let method = HTTPMethod.get(.parameters(parameters))

        return Request<[Account]>(path: "/api/v1/accounts/\(id)/followers", method: method)
    }

    /// Gets who account is following.
    ///
    /// - Parameters:
    ///   - id: The account id
    ///   - range: The bounds used when requesting data from Mastodon.
    /// - Returns: Request for `[Account]`.
    public static func following(id: String, range: RequestRange = .default) -> Request<[Account]> {
        let parameters = range.parameters(limit: between(1, and: 80, default: 40))
        let method = HTTPMethod.get(.parameters(parameters))

        return Request<[Account]>(path: "/api/v1/accounts/\(id)/following", method: method)
    }
    
    /// Follow suggestions.
    ///
    /// - Returns: Request for `[Account]`.
    public static func followSuggestions() -> Request<[Account]> {
        return Request<[Account]>(path: "/api/v1/suggestions", method: .get(.empty))
    }
    
    /// Delete follow suggestion.
    ///
    /// - Returns: Request for `[Account]`.
    public static func deleteFollowSuggestion(id: String) -> Request<Empty> {
        return Request<Empty>(path: "/api/v1/suggestions/\(id)", method: .delete(.empty))
    }
    
    /// Endorse an account.
    ///
    /// - Parameters:
    ///   - id: The account id
    /// - Returns: Request for `Relationship`.
    public static func endorse(id: String) -> Request<Relationship> {
        return Request<Relationship>(path: "/api/v1/accounts/\(id)/pin", method: .post(.empty))
    }
    
    /// Remove endorsement from an account.
    ///
    /// - Parameters:
    ///   - id: The account id
    /// - Returns: Request for `Relationship`.
    public static func endorseRemove(id: String) -> Request<Relationship> {
        return Request<Relationship>(path: "/api/v1/accounts/\(id)/unpin", method: .post(.empty))
    }
    
    /// Get endorsements.
    ///
    /// - Returns: Request for `[Account]`.
    public static func allEndorsements() -> Request<[Account]> {
        return Request<[Account]>(path: "/api/v1/endorsements", method: .get(.empty))
    }

    /// Gets an account's statuses.
    ///
    /// - Parameters:
    ///   - id: The account id.
    ///   - mediaOnly: Only return statuses that have media attachments.
    ///   - pinnedOnly: Only return statuses that have been pinned.
    ///   - excludeReplies: Skip statuses that reply to other statuses.
    ///   - excludeReblogs: Skip statuses that are boosts.
    ///   - range: The bounds used when requesting data from Mastodon.
    /// - Returns: Request for `[Status]`.
    public static func statuses(id: String,
                                mediaOnly: Bool? = nil,
                                pinnedOnly: Bool? = nil,
                                excludeReplies: Bool? = nil,
                                excludeReblogs: Bool? = nil,
                                range: RequestRange = .default) -> Request<[Status]> {
        let rangeParameters = range.parameters(limit: between(1, and: 40, default: 20)) ?? []
        let parameters = rangeParameters + [
            Parameter(name: "only_media", value: mediaOnly.flatMap(trueOrNil)),
            Parameter(name: "pinned", value: pinnedOnly.flatMap(trueOrNil)),
            Parameter(name: "exclude_replies", value: excludeReplies.flatMap(trueOrNil)),
            Parameter(name: "exclude_reblogs", value: excludeReblogs.flatMap(trueOrNil))
        ]

        let method = HTTPMethod.get(.parameters(parameters))
        return Request<[Status]>(path: "/api/v1/accounts/\(id)/statuses", method: method)
    }

    /// Follows an account.
    ///
    /// - Parameter id: The account id.
    /// - Parameter reblogs: Whether to display the account's reblogs on the home timeline.
    /// - Returns: Request for `Account`.
    public static func follow(id: String, reblogs: Bool) -> Request<Account> {
        var reb = "true"
        if reblogs == false {
            reb = "false"
        }
        let parameter = [Parameter(name: "reblogs", value: reb)]
        let method = HTTPMethod.post(.parameters(parameter))

        return Request<Account>(path: "/api/v1/accounts/\(id)/follow", method: method)
    }

    /// Unfollow an account.
    ///
    /// - Parameter id: The account id.
    /// - Returns: Request for `Account`.
    public static func unfollow(id: String) -> Request<Account> {
        return Request<Account>(path: "/api/v1/accounts/\(id)/unfollow", method: .post(.empty))
    }

    /// Follows a remote user:.
    ///
    /// - Parameter uri: The 'username@domain' of the remote user to follow.
    /// - Returns: Request for `Account`.
    public static func remoteFollow(uri: String) -> Request<Account> {
        let parameter = [Parameter(name: "uri", value: uri)]
        let method = HTTPMethod.post(.parameters(parameter))

        return Request<Account>(path: "/api/v1/follows", method: method)
    }

    /// Blocks an account.
    ///
    /// - Parameter id: The account id.
    /// - Returns: Request for `Relationship`.
    public static func block(id: String) -> Request<Relationship> {
        return Request<Relationship>(path: "/api/v1/accounts/\(id)/block", method: .post(.empty))
    }

    /// Unblocks an account.
    ///
    /// - Parameter id: The account id.
    /// - Returns: Request for `Relationship`.
    public static func unblock(id: String) -> Request<Relationship> {
        return Request<Relationship>(path: "/api/v1/accounts/\(id)/unblock", method: .post(.empty))
    }

    /// Mutes an account.
    ///
    /// - Parameter id: The account id.
    /// - Returns: Request for `Relationship`.
    public static func mute(id: String) -> Request<Relationship> {
        return Request<Relationship>(path: "/api/v1/accounts/\(id)/mute", method: .post(.empty))
    }

    /// Unmutes an account.
    ///
    /// - Parameter id: The account id.
    /// - Returns: Request for `Relationship`.
    public static func unmute(id: String) -> Request<Relationship> {
        return Request<Relationship>(path: "/api/v1/accounts/\(id)/unmute", method: .post(.empty))
    }

    /// Gets an account's relationships.
    ///
    /// - Parameter ids: The account's ids.
    /// - Returns: Request for `[Relationship]`.
    public static func relationships(ids: [String]) -> Request<[Relationship]> {
        let parameters = ids.map(toArrayOfParameters(withName: "id"))
        let method = HTTPMethod.get(.parameters(parameters))

        return Request<[Relationship]>(path: "/api/v1/accounts/relationships", method: method)
    }

    /// Searches for accounts.
    ///
    /// - Parameters:
    ///   - query: What to search for.
    ///   - limit: Maximum number of matching accounts to return (default: 40).
    ///   - following: Limit the search to following (default: false).
    /// - Returns: Request for `[Account]`.
    public static func search(query: String, limit: Int? = nil, following: Bool? = nil) -> Request<[Account]> {
        let toLimitBounds = between(1, and: 80, default: 40)
        let parameters = [
            Parameter(name: "q", value: query),
            Parameter(name: "limit", value: limit.map(toLimitBounds).flatMap(toOptionalString)),
            Parameter(name: "following", value: following.flatMap(trueOrNil))
        ]

        let method = HTTPMethod.get(.parameters(parameters))
        return Request<[Account]>(path: "/api/v1/accounts/search", method: method)
    }
}
